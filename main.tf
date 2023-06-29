terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Definition de la région de travail
provider "aws" {
  region = "us-west-2"
}

# Création d'un référentiel pour déposer notre image DOCKER
resource "aws_ecr_repository" "studi_ecf-nestjs" {
  name = "studi/ecf_frontend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Data source définissant qui nous sommes
data "aws_caller_identity" "current" {}

# Ajout d'une règle pour supprimer automatiquement les
# images non tagués.
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

# Ajouter notre image Docker "hello_nest:1.0"
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
