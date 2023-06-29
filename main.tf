terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Region's working definition
provider "aws" {
  region = "us-west-2"
}

# Create a registry for storing Docker image(s)
resource "aws_ecr_repository" "studi_ecf-nestjs" {
  name = "studi/ecf_frontend"

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
	            "description": "Garde la derniere 1 image non taguée.",
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

# Add our Docker image "hello_nest:1.0"
resource "null_resource" "docker_packaging" {
	
	  provisioner "local-exec" {
	    command = <<EOF
	    aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-west-2.amazonaws.com
	    docker build -t "${aws_ecr_repository.studi_ecf-nestjs.repository_url}:latest" -f dockerfile .
	    docker push "${aws_ecr_repository.studi_ecf-nestjs.repository_url}:latest"
	    EOF
	  }
	

	  triggers = {
	    "run_at" = timestamp()
	  }
	

	  depends_on = [
	    aws_ecr_repository.studi_ecf-nestjs,
	  ]
}