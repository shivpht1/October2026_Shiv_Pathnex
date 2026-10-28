cat > coding-practice/Day28/terraform/vpc-peering.tf <<'EOF'
# Create VPC Peering Connection
resource "aws_vpc_peering_connection" "pathnex_peering" {
  vpc_id      = aws_vpc.pathnex_vpc.id
  peer_vpc_id = aws_vpc.peer_vpc.id
  auto_accept = true

  tags = {
    Name = "pathnex-vpc-peering"
  }
}

# Add route to the peer VPC
resource "aws_route" "pathnex_route" {
  route_table_id            = aws_route_table.pathnex_rt.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.pathnex_peering.id
}
EOF