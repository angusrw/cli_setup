function aws-sb-who --description "Print the sandbox identity and assert it's account 015986344084"
    set -l expected 015986344084
    set -l account (aws sts get-caller-identity --profile i-dot-ai-sandbox-auto --query Account --output text 2>&1)
    if test $status -ne 0
        set_color red
        echo "not logged in to the sandbox (run aws-sb-login)"
        set_color normal
        echo "  $account"
        return 1
    end
    if test "$account" = "$expected"
        set_color green
        echo "sandbox OK: account $account"
        set_color normal
    else
        set_color red
        echo "WRONG ACCOUNT: $account (expected $expected)"
        set_color normal
        return 1
    end
end
