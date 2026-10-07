resource "aws_iam_role" "ec2_role" {
  name = "pathnex_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-0abcd1234abcd1234"
  instance_type = "t2.medium"

  iam_instance_profile = aws_iam_role.ec2_role.name

  tags = {
    Name = "Pathnex-EC2"
  }
}