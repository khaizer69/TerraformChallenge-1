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
    Name = "khai-tf-vpc"
  }
}

# Define Public Subnet 1 in AZ1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "khai-tf-public-subnet-az1"
  }
}

# Define Public Subnet 2 in AZ2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "khai-tf-public-subnet-az2"
  }
}

# Define Private Subnet 1 in AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "khai-tf-private-subnet-az1"
  }
}

# Define Private Subnet 2 in AZ2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "khai-tf-private-subnet-az2"
  }
}

# Define internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "khai-tf-igw"
  }
}

# Define VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"

  tags = {
    Environment = "khai-tf-vpce-s3"
    Name = "khai-tf-vpc-vpce-3"
  }
}

# Define a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "khai-tf-public-rtb"
  }
}

# Associate the public subnet 1 with the public route table
resource "aws_route_table_association" "public_subnet_az1_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public.id
}

# Associate the public subnet 2 with the public route table
resource "aws_route_table_association" "public_subnet_az2_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public.id
}

# Define a route table for private subnet az1
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "khai-tf-private-rtb-az1"
  }
}

# Associate the private subnet 1 with the private route table
resource "aws_route_table_association" "private_subnet_az1_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private.id
}

# Define a route table for private subnet az2
resource "aws_route_table_az2" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "khai-tf-private-rtb-az2"
  }
}


# Associate the private subnet 2 with the private route table
resource "aws_route_table_association" "private_subnet_az2_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private.id
}
