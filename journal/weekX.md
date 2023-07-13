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


