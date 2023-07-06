#!/bin/bash

# Definition :
## Execute shell script will do :

#      This is 'multi stage' dockerfile with targets test ans production

# 1_ : Execute units tests while building the image using the target : "test"

# 2_ : If the last build is successful, do the "production" build.

# 3_ : Ececute "docker login" command line to our fresh AWS container registry. AWS credentials given by a AWS cli command.

# 4_ : Push the builded production Docker image to the studi/ecf-nestjs ECR registry.


# @param $1 = AWS account id provided by the "aws_caller_identity" Terraform data source object
# @param $2 = ECR repository url given by the "aws_ecr_repository" Terraform ressource object

ACCOUNT=$1
ECR_URL=$2

IMAGE_NAME="$ECR_URL:latest"

if docker build -t studi_ecf-nestjs:test -f ./dockerfile --target test .
then
    echo '------'
    echo ''
    echo 'Test build passed!'
    echo 'Now build and push to production.'
    echo ''
    echo '------'
    echo ''
    
    docker build -t $IMAGE_NAME -f ./dockerfile --target production .
    aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.us-west-2.amazonaws.com
    docker push $IMAGE_NAME
else
    echo 'The test build phase faild.'
fi
