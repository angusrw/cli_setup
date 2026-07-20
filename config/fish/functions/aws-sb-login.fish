function aws-sb-login --description "Log in to the i-dot-ai Bedrock sandbox and verify the account (pass --remote for headless/SSH)"
    aws login --profile i-dot-ai-sandbox $argv; or return $status
    aws-sb-who
end
