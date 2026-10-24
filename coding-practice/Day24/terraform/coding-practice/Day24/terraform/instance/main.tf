cat > coding-practice/Day24/terraform/instance/main.tf <<'EOF'
variable "vpc_id" {
  description = "VPC ID where the instance will be deployed"
  type        = string
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_instance" "pathnex" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  subnet_id = data.aws_subnets.selected.ids[0]

  tags = {
    Name = "pathnex-instance"
  }
}

output "instance_id" {
  description = "ID of the Pathnex EC2 instance"
  value       = aws_instance.pathnex.id
}
EOF