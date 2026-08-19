# AGENTS: do not run this against prod unless the user has expressly asked you
# to. Not to check a hunch or confirm a number. Prisma Studio is a read-WRITE
# GUI — rows can be edited and deleted from the browser with one click. The
# read-only session guard below is a guardrail, not a lock. Never use it to
# write, edit or delete; if a write is needed, describe what it would change and
# how many rows, and let the user do it.

function annotation-studio --description "Prisma Studio against annotation-db (dev|prod), read-only by default"
    set -l env $argv[1]
    if not contains -- "$env" dev prod
        echo "usage: annotation-studio dev|prod [--writable]"
        echo "  --writable  allow edits (dev only)"
        return 1
    end

    set -l writable false
    if contains -- --writable $argv[2..-1]
        set writable true
    end

    set -l repo /Users/angus.williams/repos/annotation/frontend
    if not test -f $repo/prisma/schema.prisma
        echo "no schema at $repo/prisma/schema.prisma"
        return 1
    end

    if test "$env" = prod
        if test $writable = true
            echo "refusing: --writable is not allowed against prod"
            return 1
        end
        read -l -P "open PROD in Prisma Studio? type 'prod' to confirm: " reply
        if test "$reply" != prod
            echo "aborted"
            return 1
        end
    end

    set -l host i-dot-ai-$env-annotation-db.cluster-cxsxlhc4gboy.eu-west-2.rds.amazonaws.com
    set -l json (aws-ai aws secretsmanager get-secret-value --region eu-west-2 \
        --secret-id i-dot-ai-$env-annotation-db-db-master-credentials \
        --query SecretString --output text)
    or begin
        echo "couldn't fetch secret — are you authed? try: aws-who"
        return 1
    end

    # The password goes into a URI, so percent-encode it — it may contain
    # reserved characters that would otherwise split the connection string.
    set -l pw (echo $json | python3 -c 'import sys,json,urllib.parse;print(urllib.parse.quote(json.load(sys.stdin)["password"], safe=""))')

    set -l url "postgresql://postgres:$pw@$host:5432/annotation_db?sslmode=require"
    if test $writable = false
        # Postgres session guard: any INSERT/UPDATE/DELETE Studio attempts errors
        # out rather than landing. Same idea as PGOPTIONS in annotation-db.
        set url "$url&options=-c%20default_transaction_read_only%3Don"
    end

    set -lx DATABASE_URL $url
    if test $writable = true
        echo "Prisma Studio → $env (WRITABLE — edits will land)"
    else
        echo "Prisma Studio → $env (read-only session)"
    end

    # Prisma 7 dropped --schema from `studio`: prisma.config.ts resolves the
    # schema (relative, so cwd must be the frontend dir) and reads DATABASE_URL
    # from the environment. Its `import "dotenv/config"` won't clobber ours —
    # dotenv leaves existing vars alone.
    pushd $repo
    npx prisma studio
    set -l status_code $status
    popd
    return $status_code
end
