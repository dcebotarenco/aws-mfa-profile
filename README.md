## About

Shell script that configures locally and a profile with temporary credentials.

### user MFA Usage

```
./mfa.sh authenticatorCode
```

```shell 
aws s3 ls --profile mfa
```

### assume role MFA Usage

```
./role.sh arn:aws:iam::22222222:role/theRole authenticatorCode
```

```shell 
aws s3 ls --profile theRole
```

### Requirements:
JQ: https://formulae.brew.sh/formula/jq

AWS CLI: https://aws.amazon.com/cli/ 