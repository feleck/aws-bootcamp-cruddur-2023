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