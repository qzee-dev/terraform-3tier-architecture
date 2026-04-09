###########################################################################
  Cloudwatch Memory Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "memory-used-over-80"
  namespace           = "CWAgent"
  metric_name         = "mem_used_percent"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.memory_scale_out.arn]
}
###########################################################################
  Cloudwatch Container Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "container_restarts" {
  alarm_name          = "container-restart-detected"
  alarm_description   = "Triggers when any Docker container restarts on ASG instances"
  
  namespace           = "CWAgent"
  metric_name         = "container_restarts"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
###########################################################################
Cloud watch Alb Latency Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "alb_latency_high" {
  alarm_name          = "alb-latency-high"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "TargetResponseTime"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 3
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    TargetGroup  = aws_lb_target_group.app_tg.arn_suffix
    LoadBalancer = aws_lb.app_lb.arn_suffix
  }
}
###########################################################################
Network throughput Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  alarm_name          = "network-out-high"
  namespace           = "AWS/EC2"
  metric_name         = "NetworkOut"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 500000000
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
###########################################################################
Container restart Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "container_restarts_detected" {
  alarm_name          = "${var.project_name}-${var.environment}-container-restarts"
  alarm_description   = "Container restart detected on ASG instances"
  namespace           = "CWAgent"
  metric_name         = "container_restarts"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]
}





