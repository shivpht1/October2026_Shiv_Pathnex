cat > coding-practice/Day25/terraform/monitoring.tf <<'EOF'
resource "aws_sns_topic" "pathnex_alerts" {
  name = "pathnex-alerts"
}

resource "aws_cloudwatch_metric_alarm" "pathnex_cpu_alarm" {
  alarm_name          = "pathnex-cpu-utilization-high"
  alarm_description   = "Triggers when EC2 CPU utilization exceeds 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.pathnex_ec2.id
  }

  alarm_actions = [aws_sns_topic.pathnex_alerts.arn]
}
EOF