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
    S3AccessForSync:
```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
			    "s3:PutObject",
			    "s3:GetObject",
			    "s3:ListBucket",
			    "s3:DeleteObject"
			 ],
			"Resource": [
			    "arn:aws:s3:::awsbootcamp.online/*",
			    "arn:aws:s3:::awsbootcamp.online"
			]
		}
	]
}
```


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
(WeekX Recconect DB - 6:25)
Need to update service template(??)       RoleName: CruddurServiceTaskRole (line 229)

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
check version of flask - rollbar already corrected (link to line 102 in backend-flask/app.py)

RDS:
add new rule () to SG(CrdDbRDSSG) postgres - my ip for time beeing, to change
change GP_SG_ID and GP_SG_RULE_ID to added sec group and rule
and run ./bin/rds/update-sg-rule 
(GITPOD_IP worked like a charm ;)
./bin/db/connect gives FATAL:  password authentication failed for user "cruddurroot"
need to fix it, load a schema and seed data
updated the password and it worked

prepare migration to run or run it by hand
connect; \dt users; \d users # d for describe
CONNECTION_URL=$PROD_CONNECTION_URL ./bin/db/migrate
which added bio to users table

Recreate Cognito - clear users?

So running api.awsbootcamp.online/api/activities/home shows (504) "upstream request timeout" (probaly no data in RDS?)
but when trying to register - the same like in video - Access Denied
#### Single Page Application Routing
frontend template -> CloudFront, added:
```yaml
    CustomErrorResponses:
        - ErrorCode: 403
        ResponseCode: 200
        ResponsePagePath: /index.html
```
error at confirmation page:
PostConfirmation failed with error local variable 'conn' referenced before assignment.

Lambda / Functions / cruddur-post-confirmation
change CONNECTION_URL in params

another error:
PostConfirmation failed with error 2023-07-17T14:06:55.866Z c23fc8a3-f036-4fc5-92d5-8710c6d91f23 Task timed out after 3.01 seconds.

Create new SecurityGroup: CognitoLambdaSG / For the lambda that needs to connect to Postgres in correct VPC
then go to sg-00d82d686df079761 - CrdDbRDSSG
Edit inbound rules / Add rule: PostgreSQL, Source: CognitoLambdaSG

Then in Configurtion of Lambda - change VPC, Public Subnets and connect CognitoLambdaSG
Finally - we're in!
Signed in, wrote a crud and - nothing happend.

I had something in backend-flask service:
`
error connecting in 'pool-1': connection failed: FATAL: password authentication failed for user "cruddurroot"
connection to server at "cruddur-instance.cqch2tuaw2nz.eu-west-1.rds.amazonaws.com" (10.0.11.15), port 5432 failed: FATAL: no pg_hba.conf entry for host "10.0.10.238", user "cruddurroot", database <b>"cruddurroot"</b>, no encryption
`
and Rollbar also shows:
`
#61 AttributeError: 'PoolTimeout' object has no attribute 'pgerror'
#52 PoolTimeout: couldn't get a connection after 30.0 sec
`
Updated lambda (post-confirmation)

#### build / push / register / deploy in ECS
with corrected CONNeCTIOn_URL (production with updated pass)
api....activities/home showed []

#### In case of necessity of changing RDS pass:
RDS, gitpod env, local env, lambda (cruddur-post-confirmation), rebuild backend-flask, SSM (Systems Manager) - Parameter Store,

So to make it work - seed data!!!

# DDB
Removed hard coded user to cognito_user_id (create activities) and than rollout:
### try CICD!
pushed current state and create pull request in github (to prod)
Source succeded but build failed

(GitHubRepo = 'feleck/aws-bootcamp-cruddur-2023' was set correctly earlier)

Error:

`
Error calling batchGetBuilds: User: arn:aws:sts::444282218245:assumed-role/CrdCicd-CodePipelineRole-FOHX5A8R4HIK/1689684041055 is not authorized to perform: codebuild:BatchGetBuilds on resource: arn:aws:codebuild:eu-west-1:444282218245:project/CodeBuild-jVg56w52fkuD because no identity-based policy allows the codebuild:BatchGetBuilds action (Service: AWSCodeBuild; Status Code: 400; Error Code: AccessDeniedException; Request ID: d921fe14-8e05-4054-a93d-8a288eba70ed; Proxy: null)
`

Deleted old CodeBuild -> Build projects

`
is not authorized to perform: codebuild:BatchGetBuilds
`
Retried build and same error:
`[Container] 2023/07/18 13:41:47 Waiting for agent ping
[Container] 2023/07/18 13:41:48 Waiting for DOWNLOAD_SOURCE
AccessDenied: Access Denied
    status code: 403, request id: 96KYTW0Q30FT9V3B, host id: C/+ft3zw+XZr9KpmMbAf7R4ZjpPezmvSUD76uupbklPTBhQYVZJy6hYZStw54tdb1X40T+FtgDQ= for primary source and source version arn:aws:s3:::codepipeline-artifacts.awsbootcamp.online/CrdCicd-Pipeline-B1I/Source/hboHRXi
`

after a few fixes image was build! And deployed! 

But didn't work - so up to debugging! (probably need to reseed data?)

# JWT Refactor

Added close to reply form.
JWT decorator to keep DRY!
modified app.py and cognito_jwt_token.py (backend-flask lib)

# Refactor App.py

done more refactoring
and some more fixes

# Refactor Flask routes
another refactor - routes, helpers, services

# Replies

Reply form and backend.
Write migration to change reply_to_activity_uuid integer to string in activities table/

```sh
./bin/generate/migration reply_to_activity_uuid_to_string
```

```sql
ALTER TABLE activities
ALTER COLUMN reply_to_activity_uuid TYPE text USING reply_to_activity_uuid::text;
ALTER TABLE activities
ALTER COLUMN reply_to_activity_uuid TYPE uuid USING reply_to_activity_uuid::uuid;
```

and run:
```sh
./bin/db/migrate
```

# Error handling
'nothing to see here yet' in activities feed
added errors showing (with backend updates)

about 1h 5m
create Requests and refactor React pages

# Clean up 1
time expire (and other) corrected, back button on Crud added, 

# Clean up 2
pushing to production and bugs fixing
./bin/db/connect prod 
\x
\d activities
\d users
select * from users;
select * form activities;
CONNECTION_URL=$PROD_CONNECTION_URL ./bin/db/migrate

### For backend:
merge main to prod -> CodePipeline (after pull request and merge) - Source Succeeded, Build Succeeded, Deploy Succeeded.


### For frontend:
./bin/frontend/static-build
fixed some bugs

gem install aws_s3_website_sync dotenv
sync tool - 
./bin/frontend/sync

and updated successfuly.

Added DDB_MESSAGE_TABLE env var to CloudFormation service template and toml config file

(bundle install and bundle update --bundler)

./bin/cfn/service

## Create MachineUser (IAM)

CloudFormation Machine User (Role) - template.yaml, config.toml and deploy script (./bin/cfn/machineuser)

Then we have to generate some security credentials: IAM, Users, cruddur-machine-user, security-credentials:
Access keys, create Access key, Command Line Interface (CLI), select 
I understand the above recommendation and want to proceed to create an access key. and Create.
Them SSM (Systems Manager/Parameter Store) and update 
cruddur/backend-flask/AWS_ACCESS_KEY_ID	
cruddur/backend-flask/AWS_SECRET_ACCESS_KEY

trigger CodePipeline -> Release Change

UploadAvatar Lambda - Access-Control-Allow-Origin updated to prod url

Needed to change S3 assets bucket to new CloudFront arn
and domain to Cross-origin resource sharing (CORS)  in cruddur-uploaded-avatars-awsbootcamp.online bucket

added REACT_APP_API_GATEWAY_ENDPOINT_URL=https://ozj0z3xkpf.execute-api.eu-west-1.amazonaws.com in bin/frontend/static-build script

# Rollbar fix
with FLASK_ENV

https://app.diagrams.net/#G1owRqCZTUMwxMSn0DN3_cQ59r64Qy8iFA

Diagram ready
