
resource "aws_iam_user" "pathnex_user" {
  name = "pathnex_user"
}

resource "aws_iam_policy" "pathnex_policy" {
  name        = "pathnex-policy"
  description = "Allow listing objects in the Pathnex S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::pathnex-bucket"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "pathnex_attachment" {
  user       = aws_iam_user.pathnex_user.name
  policy_arn = aws_iam_policy.pathnex_policy.arn
}
