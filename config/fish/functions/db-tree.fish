function db-tree --description "Tree of databases → tables in an annotation-db cluster (dev|prod). Add 'counts' for cols/rows per table."
    set -l env $argv[1]
    if not contains -- "$env" dev prod
        echo "usage: db-tree dev|prod [counts]"
        return 1
    end
    set -l counts 0
    test "$argv[2]" = counts; and set counts 1

    set -l host i-dot-ai-$env-annotation-db.cluster-cxsxlhc4gboy.eu-west-2.rds.amazonaws.com
    set -l json (aws-ai aws secretsmanager get-secret-value --region eu-west-2 \
        --secret-id i-dot-ai-$env-annotation-db-db-master-credentials \
        --query SecretString --output text)
    or return 1
    set -lx PGPASSWORD (echo $json | python3 -c 'import sys,json;print(json.load(sys.stdin)["password"])')
    set -lx PGSSLMODE require
    set -lx PGGSSENCMODE disable

    for db in (psql -h $host -U postgres -d postgres -tAc \
        "select datname from pg_database where not datistemplate and datname not in ('rdsadmin') order by 1")
        echo "📁 $db"
        if test $counts -eq 0
            psql -h $host -U postgres -d $db -tAc \
                "select '   • '||schemaname||'.'||tablename from pg_tables \
                 where schemaname not in ('pg_catalog','information_schema') order by schemaname, tablename"
        else
            for row in (psql -h $host -U postgres -d $db -tAF '|' -c \
                "select schemaname, tablename from pg_tables \
                 where schemaname not in ('pg_catalog','information_schema') order by schemaname, tablename")
                set -l p (string split '|' $row)
                set -l stats (psql -h $host -U postgres -d $db -tAF '|' -c \
                    "select (select count(*) from \"$p[1]\".\"$p[2]\"), \
                            (select count(*) from information_schema.columns \
                             where table_schema='$p[1]' and table_name='$p[2]')")
                set -l s (string split '|' $stats)
                printf '   • %s.%s — %s cols, %s rows\n' $p[1] $p[2] $s[2] $s[1]
            end
        end
    end
end
