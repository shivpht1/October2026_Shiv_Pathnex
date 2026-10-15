
resource "aws_lb" "pathnex_lb" {
  name               = "pathnex-day15-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.allow_ssh_http.id
  ]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name        = "Pathnex-Day15-ALB"
    Environment = "Practice"
  }
}

resource "aws_instance" "pathnex_ec2" {
  ami                    = "REPLACE_WITH_VALID_AMI_ID"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name        = "Pathnex-Day15-EC2"
    Environment = "Practice"
  }
}
