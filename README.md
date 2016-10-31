# Lambda Deployment Wrapper
Generic script to build, deploy and manage python lambda functions in C.D enviroment. Function details can be set in conf directory. 

##Requirements
* Python 2.7 +
* Virtualenv
* Bash
* Functioning AWS config i.e exported AWS_ACCESS_KEY_ID or setup with aws cli.

##Base Setup
* Clone the repo 
* Create S3 bucket to host config
```
aws s3 mb s3://lambda-myfunction-config --region eu-west-1
```
* Create S3 bucket to host deployment bundles
```
aws s3 mb s3://lambda-myfunction --region eu-west-1
```
* Create a config.json file to host lambda function variables in the config folder.

* Edit the config/build.conf to taste. Read the code for more details

* Setup the build enviroment
```
./deploy-wrapper.py setup
```
* deploy 1st version of the function
```
./deploy-wrapper.py init
```
* Create 3 new Lambda aliases
```
aws lambda create-alias --name DEV --function-name lambda-myfunction --function-version=1
aws lambda create-alias --name STAGE --function-name lambda-myfunction --function-version=1
aws lambda create-alias --name PROD --function-name lambda-myfunction --function-version=1
```
* Deploy function and config to production env (alias)
```
deploy-wrapper.py --env PROD
```
* Update config in STAGE
```
deploy-wrapper.py config STAGE
```
##Additonal Usage
* Promote STAGE function version to PROD
```
./deploy-wrapper.py promote STAGE PROD
```
* Clean-up old log files and deployment bundles
```
./deploy-wrapper.py clean
```

