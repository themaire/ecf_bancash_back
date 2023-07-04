# ecf_bancash_back repo.
This is a NestJs dockerized demo application published on AWS ECR via Terraform


## Goal :

<p>>__ Create a NestJS demo app into a Docker image.</p>
<p>>__ Put this image into a Docker image registry. I use AWS Elastic Container Registry (ECR).</p>
<p>>__ All is wrapped with the tool Terraform.</p>


Make sur to have docker, terraform and aws cli command line tools installed and configured on your machine. Then, you can use the Terraform's main.tf file by :

Usage :
```
terraform init
terraform plan # For prevew what will do
terraform apply
```



## Credits
Inspired from : 
https://www.linkedin.com/pulse/how-upload-docker-images-aws-ecr-using-terraform-hendrix-roa/
and various Hashicorp documentation pages (https://developer.hashicorp.com/terraform/docs).