cat > coding-practice/Day21/terraform/s3-backup-replication.tf <<'EOF'
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
  region = var.source_region
}

variable "source_region" {
  description = "AWS region for the primary backup bucket"
  type        = string
  default     = "us-east-1"
}

variable "destination_region" {
  description = "AWS region for the replica bucket"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_suffix" {
  description = "Globally unique suffix for bucket names"
  type        = string
}

resource "aws_s3_bucket" "source" {
  bucket = "pathnex-backup-${var.bucket_suffix}"
}

resource "aws_s3_bucket" "destination" {
  provider = aws.destination
  bucket   = "pathnex-replica-${var.bucket_suffix}"
}

provider "aws" {
  alias  = "destination"
  region = var.destination_region
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "replication" {
  name = "pathnex-s3-replication-${var.bucket_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "replication" {
  name = "pathnex-s3-replication-policy"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = [aws_s3_bucket.source.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = ["${aws_s3_bucket.source.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = ["${aws_s3_bucket.destination.arn}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "backup" {
  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_versioning.destination
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id     = "cross-region-backup"
    status = "Enabled"

    filter {}

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}

output "source_bucket_name" {
  value = aws_s3_bucket.source.bucket
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination.bucket
}
EOF