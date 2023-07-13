# Week 10 — CloudFormation Part 1

## Vid 1
[AWS CF Templates](https://aws.amazon.com/cloudformation/resources/templates/)

Just to remember: aws sts get-caller-identity
```
$ export AWS_ACCESS_KEY_ID=....
$ export AWS_SECRET_ACCESS_KEY=....
$ export AWS_DEFAULT_REGION=us-west-
```

aws cloudformation deploy

AWS / Documentation / AWS CloudFormation / User Guide (/ P)roperties )
Watch out for Update requires: Replacement (!) / No interruption etc.

Execute Change Set
    Roll back (if anything fails)
    Preserve (leave working any successful parts)

if not on CF page - try looking for solutions of CloudTrail (Event history)

aws cloudformation validate-template --template-body file://./aws/cfn/template.yaml
template.yaml is a convention

```
pip install cfn-lint
cfn-lint -t ./aws/cfn/template.yaml
```

Other soft for testing template:
TaskCat, CloudFormation Guard (Policy-As-Code)
(Rust - cargo)
```
cargo install cfn-guard
/home/crecer/.cargo/bin/cfn-guard rulegen --template ./aws/cfn/template.yaml
```

generates guard? file

> created S3 bucket (cfn-artifacts.awsbootcamp.online)

## Vid 2
Generated networking (deploy script, VPC, IGW, Attachment VPC2IWG, RouteTable, Routes (1 - local is created by default), )
When creating a VPC it will create a Route Table automatically.

## Vid 3
cluster template:
  BackendHealthCheckPort:
    Type: String
    Default: 80 # OR 4567??

  FrontendHealthCheckPort:
    Type: String
    Default: 80 # or 3000 ?????


## Vid 4
Service still fails
EC2
Target groups
CrdClu-Backe-ELSCZSRGYPFD
Edit health check settings

Override port 80 to 4567!!!!


## Vid
scripts for Cluster stack and corrections for Networking Stack finally working!


because of duplicated namespace i had an error deploying service after changing the namespace to cruddurCFN I managed to deploy network, cluster and service

## CFN RDS

DB Instance 
    - Deletion Policy
    - UpdateReplacePolicy

    aws rds describe-db-engine-versions --default-only --engine postgres

DB_PASSWORD: - don't forget to create ENV_VAR (local, gitpod etc.)
8YG6x#c&6*yxEMCTy3c

Updated Systems Manager Parameters for new DB arn and password
cruddur-instance

update Route53 to direct to new ALB

Lambda power tuner

Installed AWS SAM-CLI (Serverless Aplication Model)
      wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip

reorganized dirs - ddb in root of an app and after some corrections (typos etc.) finally deployed DDB

CrdCicd-connection - manualy confirmed
(as in cicd week) - connect github app

after many hours of straggle - health check working - service working - page with health check working
Time to check CI/CD

Connection arn:aws:codestar-connections:eu-west-1:444282218245:connection/e5cbf836-2e04-4afd-90de-c012eea89d0c is not in an available state
Finish creating your connection
Your connection status is Pending. Choose Update pending connection.

Error calling batchGetBuilds: User: arn:aws:sts::444282218245:assumed-role/CrdCicd-CodePipelineRole-FOHX5A8R4HIK/1688984045061 is not authorized to perform: codebuild:BatchGetBuilds on resource: arn:aws:codebuild:eu-west-1:444282218245:project/CodeBuild-jVg56w52fkuD because no identity-based policy allows the codebuild:BatchGetBuilds action (Service: AWSCodeBuild; Status Code: 400; Error Code: AccessDeniedException; Request ID: 822e52d2-ea1e-456d-9fc6-b5dd2adbadb1; Proxy: null)

# CFN Static Website Hosting Frontend

ACM Certificate arn (from us-west-1 - not eu-west-1)
Hosted Zone Id from Route53 domain
        # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html#cfn-route53-aliastarget-hostedzoneid
        # Specify Z2FDTNDATAQYW2. This is always the hosted zone ID when you create an alias record that routes traffic to a CloudFront distribution.
Delete A record for domain in Route53
Record name
awsbootcamp.online
Record type
A
Value
dualstack.crdclusteralb-794118952.eu-west-1.elb.amazonaws.com.
Alias
Yes
TTL (seconds)
-
Routing policy
Simple

CloudFront Distribution deployed.

# Time to update charts for all the CloudFormation steps

