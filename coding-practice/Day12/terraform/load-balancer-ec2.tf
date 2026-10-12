
resource "aws_security_group" "allow_ssh_http" {
  name        = "pathnex-lb-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pathnex_ec2" {
  ami                    = "ami-REPLACE_WITH_VALID_AMI_ID"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "Pathnex-EC2"
  }
}

resource "aws_lb" "pathnex_lb" {
  name               = "pathnex-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name = "Pathnex-LB"
  }
}

resource "aws_lb_target_group" "pathnex_tg" {
  name     = "pathnex-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "pathnex_attachment" {
  target_group_arn = aws_lb_target_group.pathnex_tg.arn
  target_id        = aws_instance.pathnex_ec2.id
  port             = 80
}

resource "aws_lb_listener" "pathnex_listener" {
  load_balancer_arn = aws_lb.pathnex_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pathnex_tg.arn
  }
}
