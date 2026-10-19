
cat > coding-practice/Day19/terraform/cloudwatch-monitoring.tf <<'EOF'
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
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "pathnex_log_group" {
  name              = "/pathnex/application"
  retention_in_days = 14

  tags = {
    Project     = "PathNex"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_stream" "pathnex_log_stream" {
  name           = "pathnex-app-logs"
  log_group_name = aws_cloudwatch_log_group.pathnex_log_group.name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.pathnex_log_group.name
}

output "cloudwatch_log_stream_name" {
  description = "CloudWatch Log Stream name"
  value       = aws_cloudwatch_log_stream.pathnex_log_stream.name
}
EOF
