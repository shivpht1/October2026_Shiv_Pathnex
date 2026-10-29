cat > coding-practice/Day29/terraform/main.tf <<'EOF'
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
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Valid Amazon Linux AMI ID for the selected region"
  type        = string
}

resource "aws_vpc" "pathnex_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "pathnex-vpc"
  }
}

resource "aws_subnet" "pathnex_subnet" {
  vpc_id                  = aws_vpc.pathnex_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pathnex-public-subnet"
  }
}

resource "aws_internet_gateway" "pathnex_igw" {
  vpc_id = aws_vpc.pathnex_vpc.id

  tags = {
    Name = "pathnex-igw"
  }
}

resource "aws_route_table" "pathnex_rt" {
  vpc_id = aws_vpc.pathnex_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pathnex_igw.id
  }

  tags = {
    Name = "pathnex-route-table"
  }
}

resource "aws_route_table_association" "pathnex_rta" {
  subnet_id      = aws_subnet.pathnex_subnet.id
  route_table_id = aws_route_table.pathnex_rt.id
}

resource "aws_security_group" "pathnex_sg" {
  name        = "pathnex-app-sg"
  description = "Allow HTTP traffic to the demo application"
  vpc_id      = aws_vpc.pathnex_vpc.id

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "pathnex-app-sg"
  }
}

resource "aws_instance" "pathnex_app" {
  ami                         = var.ami_id
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.pathnex_subnet.id
  vpc_security_group_ids      = [aws_security_group.pathnex_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "pathnex-app"
  }
}
EOF