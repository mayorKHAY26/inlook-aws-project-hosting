resource "aws_cloudwatch_log_group" "inlook_application_logs" {
  name              = "/aws/inlook/application"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-application-log-group"
    Project     = "Inlook"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "inlook_jenkins_cpu_alarm" {
  alarm_name          = "${var.project_name}-jenkins-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when Inlook Jenkins EC2 CPU exceeds 80 percent"

  dimensions = {
    InstanceId = aws_instance.inlook_jenkins.id
  }

  tags = {
    Name        = "${var.project_name}-jenkins-cpu-alarm"
    Project     = "Inlook"
    Environment = var.environment
  }
}