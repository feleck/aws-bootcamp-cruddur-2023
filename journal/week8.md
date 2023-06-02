# Week 8 — Serverless Image Processing

After a week of struggling I finally managed to upload Avatars with cognito_user_uuid.
Some tricks:
Make sure API Gateway is set correctly - 
route: /avatars/key_upload with method POST and attached both: integration: lambda CruddurAvatarUpload and authorization: CruddurApiGatewayLambdaAuthorizer whereas route: /{proxy+} method OPPPTINS and only integration with lambda CruddurAvatarUpload

Remember to add env variables in both lamdas: UPLOADS_BUCKET_NAME CruddurAvatarUpload and USER_POOL_ID, CLIENT_ID for CruddurApiGatewayLambdaAuthorizer

Another important aspects are: authorization header in ProfileForm.js:
 s3uploadkey, headers: {
  'Origin': process.env.REACT_APP_FRONTEND_URL,
  'Authorization': `${access_token}`,
  ...}
and then accordingly in function.rb
token = event['headers']['authorization']

That finally made my app upload avatars with filename as user uuid.