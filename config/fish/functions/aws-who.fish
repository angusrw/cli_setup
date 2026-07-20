function aws-who --description "Print the assumed-role identity for the current AWS session"
    aws-ai aws sts get-caller-identity
end
