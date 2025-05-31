resource "aws_cloudwatch_log_group" "eks_logs" {
  name = "/eks/${var.cluster_name}"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Triggers when CPU exceeds 80% for 10 minutes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = { ClusterName = module.eks.cluster_name }
}

resource "aws_sns_topic" "alerts" { name = "eks-alerts" }

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # Replace with your email
}