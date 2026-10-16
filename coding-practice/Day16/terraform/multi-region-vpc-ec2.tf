
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-1"
}

resource "aws_vpc" "us_east_vpc" {
  provider   = aws.us_east
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Pathnex-US-East-VPC"
  }
}

resource "aws_vpc" "us_west_vpc" {
  provider   = aws.us_west
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Pathnex-US-West-VPC"
  }
}

resource "aws_instance" "us_east_ec2" {
  provider      = aws.us_east
  ami           = var.us_east_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Pathnex-US-East-EC2"
  }
}

resource "aws_instance" "us_west_ec2" {
  provider      = aws.us_west
  ami           = var.us_west_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "Pathnex-US-West-EC2"
  }
}

variable "us_east_ami_id" {
  description = "Valid AMI ID in us-east-1"
  type        = string
}

variable "us_west_ami_id" {
  description = "Valid AMI ID in us-west-1"
  type        = string
}
