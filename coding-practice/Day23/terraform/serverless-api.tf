cat > coding-practice/Day23/terraform/serverless-api.tf <<'EOF'
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
  description = "AWS region for serverless resources"
  type        = string
  default     = "us-east-1"
}

variable "lambda_role_arn" {
  description = "ARN of an existing Lambda execution role"
  type        = string
}

variable "lambda_zip_file" {
  description = "Path to the Lambda deployment ZIP"
  type        = string
  default     = "lambda.zip"
}

resource "aws_lambda_function" "pathnex_lambda" {
  function_name    = "pathnex-lambda"
  runtime          = "python3.12"
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  filename         = var.lambda_zip_file
  source_code_hash = filebase64sha256(var.lambda_zip_file)

  timeout     = 10
  memory_size = 128
}

resource "aws_api_gateway_rest_api" "pathnex_api" {
  name        = "pathnex-api"
  description = "Serverless API for Pathnex"
}

resource "aws_api_gateway_resource" "pathnex_resource" {
  rest_api_id = aws_api_gateway_rest_api.pathnex_api.id
  parent_id   = aws_api_gateway_rest_api.pathnex_api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "pathnex_method" {
  rest_api_id   = aws_api_gateway_rest_api.pathnex_api.id
  resource_id   = aws_api_gateway_resource.pathnex_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.pathnex_api.id
  resource_id             = aws_api_gateway_resource.pathnex_resource.id
  http_method             = aws_api_gateway_method.pathnex_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.pathnex_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pathnex_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.pathnex_api.execution_arn}/*/GET/hello"
}

resource "aws_api_gateway_deployment" "pathnex_deployment" {
  rest_api_id = aws_api_gateway_rest_api.pathnex_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.pathnex_resource.id,
      aws_api_gateway_method.pathnex_method.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_lambda_permission.api_gateway
  ]
}

resource "aws_api_gateway_stage" "pathnex_stage" {
  rest_api_id   = aws_api_gateway_rest_api.pathnex_api.id
  deployment_id = aws_api_gateway_deployment.pathnex_deployment.id
  stage_name    = "dev"
}

output "api_url" {
  description = "URL for the serverless API endpoint"
  value       = "${aws_api_gateway_stage.pathnex_stage.invoke_url}/hello"
}
EOF