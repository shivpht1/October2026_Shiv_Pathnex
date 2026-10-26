cat > coding-practice/Day26/terraform/vpc-flow-logs.tf <<'EOF'
resource "aws_cloudwatch_log_group" "pathnex_flow_logs_group" {
  name              = "pathnex-flow-logs"
  retention_in_days = 30
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "pathnex-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "pathnex-vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.pathnex_flow_logs_group.arn}:*"
    }]
  })
}

resource "aws_flow_log" "pathnex_flow_log" {
  log_destination      = aws_cloudwatch_log_group.pathnex_flow_logs_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.pathnex_vpc.id
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn

  depends_on = [
    aws_iam_role_policy.vpc_flow_logs_policy
  ]
}
EOF