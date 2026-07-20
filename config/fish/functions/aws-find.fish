function aws-find --description "Search AWS resources by regex across common services"
    if test (count $argv) -eq 0
        echo "usage: aws-find <regex>"
        echo "example: aws-find 'edu|annotation'"
        return 1
    end
    set -l pattern $argv[1]

    _aws-find-section "S3 buckets" $pattern aws s3api list-buckets --query 'Buckets[].Name' --output text
    _aws-find-section "Lambda functions" $pattern aws lambda list-functions --query 'Functions[].FunctionName' --output text
    _aws-find-section "DynamoDB tables" $pattern aws dynamodb list-tables --query 'TableNames' --output text
    _aws-find-section "Secrets" $pattern aws secretsmanager list-secrets --query 'SecretList[].Name' --output text
    _aws-find-section "IAM roles" $pattern aws iam list-roles --query 'Roles[].RoleName' --output text
    _aws-find-section "CloudWatch log groups" $pattern aws logs describe-log-groups --query 'logGroups[].logGroupName' --output text
    _aws-find-section "RDS instances" $pattern aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier' --output text
    _aws-find-section "RDS clusters" $pattern aws rds describe-db-clusters --query 'DBClusters[].DBClusterIdentifier' --output text
end
