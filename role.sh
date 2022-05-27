#!/bin/sh
#./role.sh arn:aws:iam::$account:role/$roleName $code 
GET_ARN_COMMAND="aws iam list-mfa-devices | jq '.MFADevices[0].SerialNumber'" 
MFA_ARN=$(eval $GET_ARN_COMMAND)
echo $MFA_ARN

ROLE=$(echo "$1"  | sed -n "s/.*\/\(.*\).*$/\1/p")

GET_TEMPORARY_CREDENTIALS_COMMAND="aws sts assume-role --role-arn $1 --role-session-name assume-role-session --serial-number $MFA_ARN --token-code $2" 
CREDENTIALS=$(eval $GET_TEMPORARY_CREDENTIALS_COMMAND)


AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< "$CREDENTIALS") 
AWS_ACCESS_KEY_SECRET=$(jq -r '.Credentials.SecretAccessKey' <<< "$CREDENTIALS") 
AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< "$CREDENTIALS") 
AWS_REGION='us-east-1'

echo "Creating/updating profile $ROLE"
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} --profile $ROLE
aws configure set aws_secret_access_key ${AWS_ACCESS_KEY_SECRET} --profile $ROLE
aws configure set aws_session_token ${AWS_SESSION_TOKEN} --profile $ROLE
aws configure set region ${AWS_REGION} --profile $ROLE
aws configure set output "json" --profile $ROLE
