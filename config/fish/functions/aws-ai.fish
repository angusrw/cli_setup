function aws-ai --description "Run a command as ai-engineer-role via aws-vault"
    aws-vault exec ai-engineer-role -- $argv
end
