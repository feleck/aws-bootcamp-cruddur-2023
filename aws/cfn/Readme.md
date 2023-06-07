## Architecture Guide

Before you run any template, be sure to create an S3 bucket to contain all of our artifacts for CloudFormation

```
aws s3 mk s3://cfn-artifacts.awsbootcamp.online
export CFN_BUCKET="cfn-artifacts.awsbootcamp.online"
gp env CNF_BUCKET="cfn-artifacts.awsbootcamp.online"
```

> Remember bucket names are unique to the provided code example you may need to adjust

