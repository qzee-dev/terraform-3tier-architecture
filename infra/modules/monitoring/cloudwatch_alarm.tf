###########################################################################
# Cloudwatch Memory Alarm
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
    AutoScalingGroupName = var.web_asg_name
  }

  alarm_actions = [var.memory_scale_out_policy_arn]
}
###########################################################################
# Cloudwatch Container Alarm
###########################################################################
resource "aws_cloudwatch_metric_alarm" "container_restarts" {
  alarm_name        = "container-restart-detected"
  alarm_description = "Triggers when any Docker container restarts on ASG instances"

  namespace           = "CWAgent"
  metric_name         = "container_restarts"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }
}
###########################################################################
# Cloud watch Alb Latency Alarm
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
    TargetGroup  = var.app_tg_arn_suffix
    LoadBalancer = var.app_lb_arn_suffix
  }
}
###########################################################################
# Network throughput Alarm
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
    AutoScalingGroupName = var.web_asg_name
  }
}
###########################################################################
# Container restart Alarm
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
    AutoScalingGroupName = var.web_asg_name
  }

  alarm_actions = [
    aws_sns_topic.ops_alerts.arn
  ]
}

resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow SNS"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = ["kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*", "kms:DescribeKey"]
        Resource = "*"
      },
      {
        Sid    = "Allow Root Account"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_sns_topic" "ops_alerts" {
  name              = "${var.project_name}-${var.environment}-ops-alerts"
  kms_master_key_id = aws_kms_key.sns_key.id
}





