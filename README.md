### Github repository : ecf_bancash_back.

# Activité Type 2 : Déploiement d’une application en continu

Included tasks :
1. Créez une application Nodejs (hello word) à partir d’une image docker Nodejs que vous exposerez sur un port (de votre choix).
2. Dockerizez votre application Nodejs.


## Introduction :
<p>This is a NestJs dockerized demo application published on AWS ECR via Terraform</p>

### What I done :

<p>
Hour priority is to store dockerized NestJS application in a container registry on the cloud. For that, used the Terraform tool (main.ts file) in <b>only two steps :</b><br><br>
_ Step one : I described how to create a AWS Elastic Container Registry (ECR) to store hour Docker image.<br><br>
_ Step two : Local execution of Docker commands lines for log-in with AWS server, build the Docker image and finaly push it to our ECR registry.

Make sûr to have docker, terraform and aws cli command line tools installed and configured on your machine. Then, you can use the Terraform's main.tf file by :

Usage :
```
terraform init
terraform plan # For prevew what will do
terraform apply
```

# Screenshots

Step 1 : AWS console show the ecf_bancask_back registry just made :

![ScreenShot](img/ecr_registry.png)

We can list the :

![ScreenShot](img/docker_images.png)

ecf_bancask_back registry detail. We can see the image inside :

![ScreenShot](img/ecr_registry_detail.png)

## Credits
Inspired from : 
https://www.linkedin.com/pulse/how-upload-docker-images-aws-ecr-using-terraform-hendrix-roa/
and various Hashicorp documentation pages (https://developer.hashicorp.com/terraform/docs).