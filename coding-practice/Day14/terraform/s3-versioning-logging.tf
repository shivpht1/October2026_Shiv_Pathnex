
resource "aws_s3_bucket" "pathnex_bucket" {
  bucket = "pathnex-bucket"

  tags = {
    Name        = "Pathnex-Bucket"
    Environment = "Practice"
  }
}

resource "aws_s3_bucket_versioning" "pathnex_versioning" {
  bucket = aws_s3_bucket.pathnex_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "pathnex_log_bucket" {
  bucket = "pathnex-log-bucket"

  tags = {
    Name        = "Pathnex-Log-Bucket"
    Environment = "Practice"
  }
}

resource "aws_s3_bucket_logging" "pathnex_logging" {
  bucket        = aws_s3_bucket.pathnex_bucket.id
  target_bucket = aws_s3_bucket.pathnex_log_bucket.id
  target_prefix = "logs/"

  depends_on = [
    aws_s3_bucket_policy.pathnex_log_policy
  ]
}

resource "aws_s3_bucket_policy" "pathnex_log_policy" {
  bucket = aws_s3_bucket.pathnex_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "S3ServerAccessLogsPolicy"
        Effect    = "Allow"
        Principal = { Service = "logging.s3.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.pathnex_log_bucket.arn}/logs/*"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.pathnex_bucket.arn
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
