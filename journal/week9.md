# Week 9 — CI/CD with CodePipeline, CodeBuild and CodeDeploy

Created CodePipeline with connected prod branch from my repository.
Couldn't find DetectChanges option on Summary Page (Step 2 - Add source stage)

Create imagedefinitions.json - to deploy.

Crated build project - just another stage in pipeline.
main to prod merge?

(!) Enable this flag if you want to build Docker images or want your builds to get elevated privileges

buildspec.yaml file - m own account ID and ECR repo ARN, image-url, and (?) added Default region
(no need to env vars - corrected in vid2)

use parameter store (in buildspec) - do I need to copy/paste one by one by hand???
(1h 18m on first Video)

vid2
Removed VPC setting
Make sure if permissions are needed (Amazon ECR \ Repositories \ backend-flask \ Permissions \ Edit permissions)

In github create new pull request base: prod compare: main, create pull request, merge pull request and CodeBuild - and it failed:
[Container] 2023/06/05 11:52:10 Running command aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $IMAGE_URL

An error occurred (AccessDeniedException) when calling the GetAuthorizationToken operation: User: arn:aws:sts::444282218245:assumed-role/codebuild-cruddur-backend-flask-bake-image-service-role/AWSCodeBuild-f1245418-7c70-48c4-8102-05768e70716f is not authorized to perform: ecr:GetAuthorizationToken on resource: * because no identity-based policy allows the ecr:GetAuthorizationToken action
Error: Cannot perform an interactive login from a non TTY device

[Container] 2023/06/05 11:52:22 Command did not exit successfully aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $IMAGE_URL exit status 1
[Container] 2023/06/05 11:52:22 Phase complete: INSTALL State: FAILED
[Container] 2023/06/05 11:52:22 Phase context status code: COMMAND_EXECUTION_ERROR Message: Error while executing command: aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $IMAGE_URL. Reason: exit status 1


fix:
Amazon ECR \ Repositories \ backend-flask \ Permissions \ Edit permissions)
To solve this in IAM in Roles in role: "codebuild-cruddur-backend-flask-bake-image-service-role" added inline policy "cruddur-codebuild" - aws/policies/ecr-codbuild.json and finally build was successsful.

Returned to codepipeline, finished adding build stage, and deploy stage still had "Invalid action configuration"
to fix this had to add Output artifacts in build stage - ImageDefinition and then in deploy stage chenged the InputArifccts to ImageDefinition from "bake".
It occured that it was in wrong location "no matching artifact path found" changed the path       - cd $CODEBUILD_SRC_DIR in buildspec (post build stage)

Amazon Elastic Container Service \ Clusters \ cruddur \ Services \ backend-flask \ Update
Force new deployment to yes and Desired tasks to 1 (to actually start the app)
https://api.awsbootcamp.online/api/health-check and: 
{
  "success": true
}
so added 'ver' in health check and observed how merge (main to prod) triggered the deploy.
