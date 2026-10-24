mkdir -p coding-practice/Day24/terraform/vpc
mkdir -p coding-practice/Day24/terraform/instance

cat > coding-practice/Day24/terraform/main.tf <<'EOF'
module "pathnex_vpc" {
  source = "./vpc"
}

module "pathnex_instance" {
  source = "./instance"
  vpc_id = module.pathnex_vpc.vpc_id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.pathnex_instance.instance_id
}
EOF