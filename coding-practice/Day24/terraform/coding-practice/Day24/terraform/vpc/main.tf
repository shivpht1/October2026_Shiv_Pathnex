cat > coding-practice/Day24/terraform/vpc/main.tf <<'EOF'
resource "aws_vpc" "pathnex" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "pathnex-vpc"
  }
}

output "vpc_id" {
  description = "ID of the Pathnex VPC"
  value       = aws_vpc.pathnex.id
}
EOF