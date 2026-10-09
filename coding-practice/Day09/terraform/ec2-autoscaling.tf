
resource "aws_launch_configuration" "example" {
  name          = "example-config"
  image_id      = "ami-0abcd1234abcd1234"
  instance_type = "t3.medium"
}

resource "aws_autoscaling_group" "example" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = ["subnet-12345678"]

  launch_configuration = aws_launch_configuration.example.id
}
