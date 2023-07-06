# GOAL : 
## Step 1 : Create a AWS Elastic Container Registry with a custom policy rule.
## Step 2 : Build and push the nestjs demo app image to this new ECR.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

### STEP 1 - Create a ECR (AWS's docker image registry). :-)
# Create a registry for storing Docker image(s)
resource "aws_ecr_repository" "studi_ecf-nestjs" {
  name = "studi/ecf_bancask_back"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# The AWS user we are in a 'data source'.
data "aws_caller_identity" "current" {}

# Adding a policy for keeping juste one untagged image on the registry.
# Avoid too many undesired images.
resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.studi_ecf-nestjs.name

  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Always keep last 1 untagged image version.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": 1
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF

}

### STEP 2 - If 'test' build pass, than build and push the 'production' image it to ECR.  ;-)
## Execute shell script will do :

#      This is 'multi stage' dockerfile with targets test ans production

# 1_ : Execute units tests while building the image using the target : "test"

# 2_ : If the last build is successful, do the "production" build.

# 3_ : Ececute "docker login" command line to our fresh AWS container registry. AWS credentials given by a AWS cli command.

# 4_ : Push the builded production Docker image to the studi/ecf-nestjs ECR registry.

resource "null_resource" "docker_packaging" {
	
	  provisioner "local-exec" {
	    command = <<EOF
		/bin/bash ./test_build_push.sh ${data.aws_caller_identity.current.account_id} ${aws_ecr_repository.studi_ecf-nestjs.repository_url}
	    EOF
	  }
	
	  triggers = {
	    "run_at" = timestamp()
	  }
	
	  depends_on = [
	    aws_ecr_repository.studi_ecf-nestjs,
	  ]
}
