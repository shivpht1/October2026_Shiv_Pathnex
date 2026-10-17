
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_location" {
  description = "Azure deployment region"
  type        = string
  default     = "East US"
}

variable "aws_ami_id" {
  description = "Valid Linux AMI ID in us-east-1"
  type        = string
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "pathnex-aws-vpc"
    Environment = "Practice"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "pathnex-practice-rg"
  location = var.azure_location
}

resource "azurerm_virtual_network" "main" {
  name                = "pathnex-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]
}

resource "aws_instance" "pathnex_ec2" {
  ami           = var.aws_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "pathnex-aws-ec2"
  }
}

output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "azure_vnet_name" {
  value = azurerm_virtual_network.main.name
}
