cat > coding-practice/Day30/terraform/main.tf <<'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type        = string
  description = "Valid AMI ID for the selected AWS region"
}

resource "aws_vpc" "pathnex_vpc" {
  cidr_block           = "10.30.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "pathnex-day30-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.pathnex_vpc.id
  cidr_block              = "10.30.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pathnex-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.pathnex_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pathnex_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "app" {
  name   = "pathnex-day30-sg"
  vpc_id = aws_vpc.pathnex_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]

  tags = {
    Name = "pathnex-day30-app"
  }
}

output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}
EOF