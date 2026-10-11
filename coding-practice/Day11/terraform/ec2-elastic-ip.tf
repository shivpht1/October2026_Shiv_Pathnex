
resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-0abcd1234abcd1234"
  instance_type = "t3.medium"

  tags = {
    Name = "Pathnex-EC2"
  }
}

resource "aws_eip" "pathnex_eip" {
  domain   = "vpc"
  instance = aws_instance.pathnex_ec2.id

  tags = {
    Name = "Pathnex-Elastic-IP"
  }
}
