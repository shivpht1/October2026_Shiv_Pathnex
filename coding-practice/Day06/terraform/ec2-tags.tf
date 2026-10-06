provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "pathnexec2" {
    ami ="ami-o123445"
    instance_type = "r5.2xlarge"

    tags= {
        name = "Pathnex-server"
        Environment = "training"
        Owner = "Shiv"
    }