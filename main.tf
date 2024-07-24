terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


#Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # Edit below
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}

#Create VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "junjie-tf-vpc"
  }
}
