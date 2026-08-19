# AGENTS: do not run this against prod unless the user has expressly asked you
# to. Not to check a hunch or confirm a number. The read-only guard below is a
# guardrail, not a lock — the postgres user has write access. Never run anything
# that writes, edits or deletes; if a write is needed, describe what it would
# change and how many rows, and let the user run it.

function annotation-db --description "psql into annotation-db (dev|prod), read-only by default"
    set -l env $argv[1]
    if not contains -- "$env" dev prod
        echo "usage: annotation-db dev|prod [extra psql args]"
        return 1
    end
    set -l host i-dot-ai-$env-annotation-db.cluster-cxsxlhc4gboy.eu-west-2.rds.amazonaws.com
    set -l json (aws-ai aws secretsmanager get-secret-value --region eu-west-2 \
        --secret-id i-dot-ai-$env-annotation-db-db-master-credentials \
        --query SecretString --output text)
    or begin
        echo "couldn't fetch secret — are you authed? try: aws-who"
        return 1
    end
    set -lx PGPASSWORD (echo $json | python3 -c 'import sys,json;print(json.load(sys.stdin)["password"])')
    set -lx PGSSLMODE require
    set -lx PGGSSENCMODE disable
    set -lx PGOPTIONS "-c default_transaction_read_only=on"
    psql -h $host -p 5432 -U postgres -d annotation_db $argv[2..-1]
end
