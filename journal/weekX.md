# Week X

Record A of Hosted Zone for awsbootcamp.online (Route53) pointing to CloudFront
shouldn't work - nothing in this repo (bucket)
Need to run `npm run build` to build the stuff out.
Remeber do set env vars when building.
Add script static-build for production.

Clean (most) warnings ("==" to "===" in js files)
zip the build folder and upload it to bucket
in the frontend-js dir run: zip -r build.zip build/

### aws_s3_website_sync
```sh
gem install aws_s3_website_sync
gem install dotenv
```

sync local folder to s3 bucket and invalidate CloudFront cache
`Gemfile`:
```rb
source 'https://rubygems.org'

git source(:github) do |repo_name|
..
end

gem 'rake'
gem 'aws_s3_website_sync', tag: '1.0.1'
gem 'dotenv', groups: [:development, :test]
```
```sh
`bundle install`
```

`Rakefile`

proceed to sync
```sh
bundle exec rake sync
```

new env file geneartor, gem installed
run script to sync

made a change and synced it to bucket, and it worked!

Maybe done using `github actions`

Create .github/workflows dir and ruby_script.yml inside
```
name: 

on:
    push:
        branches:
            prod
jobs:
    run_script:
        runs-on: 
    
    steps:
        - name:
          usees
```


Need to create a role for sync (using github actions)
    role-to-assume: arn:aws:iam::387543059434:role/CrdSyncRole-Role-1N0SLA7KGVS8E
    aws-region: ca-central-1

IAM -> Identity providers
script aws/cfn/sync/template.yaml is creating OIDC Provider and then assumes a role to it.

Script created role and IP
(Bundler version 2.4.12-local, updated in .gitpod.yml )
1:43 Add policy (S3AccessForSync) to role (service: s3, actions: getObject, putObject, ListBucket, DeleteObject, ARN for bucket: cfn-artifacts.awsbootcamp.online, object: any)

# Reconnect DB and Post Confirmation Lambda

Build new image - for backend-flask
./bin/backend/build
./bin/backend/push 
./bin/backend/register
Amazon Elastic Container Service / Clusters / CrdClusterFargateCluster / Services select backendservice and update
service backend-flask failed to launch a task with (error ECS was unable to assume the role 'arn:aws:iam::444282218245:role/CruddurTaskRole' that was provided for this task. Please verify that the role being passed has the proper trust relationship and permissions and that your IAM user has permissions to pass this role.)

to troubleshoot -> Task definitions / backend-flask / Revision 31 /   JSON

stack actions -> detect drift

Drift status: DRIFTED
to revert? update stack and deploy again

in service template
                # decoupling to down indpedently
                ServiceName: backend-flask
                  # Fn::ImportValue:
                  #   !Sub ${ServiceStack}ServiceName

Serivce not starting after tearing down and redeploying - probably due to changes in health check ports (in console).

local compose up prod Dockerfile for backend-flask
docker-compose.yml
in build:
    context: ./backend-flask
    dockerfile: Dokerfile.prod
check version of flask
30minutes