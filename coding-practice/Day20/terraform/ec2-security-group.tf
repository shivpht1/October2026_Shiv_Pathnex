
cat > coding-practice/Day20/terraform/ec2-security-group.tf <<'EOF'
terraform {
  required_version = ">= 1.5.0"

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
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "trusted_ssh_cidr" {
  description = "Trusted IP range allowed to access SSH"
  type        = string

  validation {
    condition     = can(cidrhost(var.trusted_ssh_cidr, 0))
    error_message = "Provide a valid IPv4 CIDR range."
  }
}

resource "aws_security_group" "pathnex_sg" {
  name_prefix = "pathnex-sg-"
  description = "Allow HTTP and restricted SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from trusted IP range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.trusted_ssh_cidr]
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "pathnex-security-group"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

output "security_group_id" {
  description = "Created security group ID"
  value       = aws_security_group.pathnex_sg.id
}
EOF
