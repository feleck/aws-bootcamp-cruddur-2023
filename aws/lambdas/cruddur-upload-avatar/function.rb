require 'aws-sdk-s3'
require 'json'
require 'jwt'

def handler(event:, context:)
    # puts event
    if event['routeKey'] == "OPTIONS /{proxy+}"
        puts ({step: 'preflight', message: 'preflight CORS check'}.to_json)
        {
            headers: {
                "Access-Control-Allow-Headers": "*, Authorization",
                "Access-Control-Allow-Origin": "https://3000-feleck-awsbootcampcrudd-vraf1k96d0u.ws-eu98.gitpod.io",
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
            },
            statusCode: 200
        }
    else
        puts ({step: 'presignedurl', message: 'generate PreSignURL'}.to_json)
        token = event['headers']['authorization']
        decoded_token = JWT.decode token, nil, false
        cognito_user_uuid = decoded_token[0]['sub']
        # puts ({step: 'AUTH',user:  cognito_user_uuid }.to_json)
        bucket_name = ENV["UPLOADS_BUCKET_NAME"]
        body_hash = JSON.parse(event["body"])
        extension = body_hash["extension"]
        # object_key = "mock.jpg"
        object_key = "#{cognito_user_uuid}.#{extension}"
        # puts ({object_key: object_key}.to_json)
        s3 = Aws::S3::Resource.new
        obj = s3.bucket(bucket_name).object(object_key)
        url = obj.presigned_url(:put, expires_in: 60 * 5)
        # url
        body = {url: url}.to_json
        {
            headers: {
                "Access-Control-Allow-Headers": "*, Authorization",
                "Access-Control-Allow-Origin": "https://3000-feleck-awsbootcampcrudd-vraf1k96d0u.ws-eu98.gitpod.io",
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
            },
            statusCode: 200,
            body: body
        }
    end
end
