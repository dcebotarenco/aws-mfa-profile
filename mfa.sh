#!/bin/sh

GET_ARN_COMMAND="aws iam list-mfa-devices | jq '.MFADevices[0].SerialNumber'" 
MFA_ARN=$(eval $GET_ARN_COMMAND)
echo $MFA_ARN

GET_TEMPORARY_CREDENTIALS_COMMAND="aws sts get-session-token --serial-number $MFA_ARN --token-code $1" 
CREDENTIALS=$(eval $GET_TEMPORARY_CREDENTIALS_COMMAND)

echo $CREDENTIALS

AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< "$CREDENTIALS") 
AWS_ACCESS_KEY_SECRET=$(jq -r '.Credentials.SecretAccessKey' <<< "$CREDENTIALS") 
AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< "$CREDENTIALS") 
AWS_REGION='us-east-1'

aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} --profile mfa
aws configure set aws_secret_access_key ${AWS_ACCESS_KEY_SECRET} --profile mfa
aws configure set aws_session_token ${AWS_SESSION_TOKEN} --profile mfa
aws configure set region ${AWS_REGION} --profile mfa
aws configure set output "json" --profile mfa
