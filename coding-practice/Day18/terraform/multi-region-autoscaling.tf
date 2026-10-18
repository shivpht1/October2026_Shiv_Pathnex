
cat > coding-practice/Day18/terraform/multi-region-autoscaling.tf <<'EOF'
# Day 18: AWS Application Load Balancer and Auto Scaling Group
# Note: This example deploys in one AWS region across multiple Availability Zones.

variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Valid Amazon Linux AMI ID for the selected region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}

resource "aws_security_group" "pathnex_web_sg" {
  name        = "pathnex-web-sg"
  description = "Allow HTTP traffic and SSH from an approved source"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Restrict SSH to your own trusted IP before deploying.
  # Add an SSH ingress rule with your trusted CIDR if required.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "pathnex_lb" {
  name               = "pathnex-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pathnex_web_sg.id]
  subnets            = data.aws_subnets.public.ids
}

resource "aws_lb_target_group" "pathnex_tg" {
  name     = "pathnex-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.pathnex_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pathnex_tg.arn
  }
}

resource "aws_launch_template" "pathnex_config" {
  name_prefix   = "pathnex-web-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.pathnex_web_sg.id]

  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo "PathNex Day18 - $(hostname)" > /usr/share/nginx/html/index.html
  USERDATA
  )
}

resource "aws_autoscaling_group" "pathnex_asg" {
  name                = "pathnex-web-asg"
  desired_capacity    = 3
  min_size            = 2
  max_size            = 5
  vpc_zone_identifier = data.aws_subnets.public.ids
  target_group_arns   = [aws_lb_target_group.pathnex_tg.arn]

  launch_template {
    id      = aws_launch_template.pathnex_config.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "pathnex-web"
    propagate_at_launch = true
  }
}

output "load_balancer_dns" {
  description = "Public DNS name of the Application Load Balancer"
  value       = aws_lb.pathnex_lb.dns_name
}
EOF
