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

# Define Public Subnet 1 in AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "junjie-tf-public-subnet-az1"
  }
}

# Define Public Subnet 2 in AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "junjie-tf-public-subnet-az2"
  }
}

# Define Private Subnet 1 in AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "junjie-tf-private-subnet-az1"
  }
}

# Define Private Subnet 2 in AZ2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "junjie-tf-private-subnet-az2"
  }
}

# Define internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "junjie-tf-igw"
  }
}

# Define VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Environment = "junjie-tf-vpce-s3"
    Name = "junjie-tf-vpc-vpce-3"
  }
}