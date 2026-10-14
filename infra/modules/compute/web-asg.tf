resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  vpc_zone_identifier = [
    var.subnet1_id,
    var.subnet2_id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"  # ← KEY CHANGE: Use $Latest so new versions auto-apply
  }

  target_group_arns = [var.app_tg_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  force_delete              = false

  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }

  # ✅ THIS HANDLES AMI ROLLOUT SAFELY

  instance_refresh {
    strategy = "Rolling"
    
    preferences {
      min_healthy_percentage = 100     # Keep 100% healthy = 2 instances stay up
      max_healthy_percentage = 150     # Allow 1 extra temp instance during swap
      instance_warmup        = 180     # Wait 3 min for health checks
      skip_matching          = false   # Force update even if template config matches
      auto_rollback          = true    # Automatic rollback if refresh fails
    }

   alarm_specification {
        alarms = [
          aws_cloudwatch_metric_alarm.app_high_5xx.alarm_name,
          aws_cloudwatch_metric_alarm.app_high_latency.alarm_name
        ]
      

    
    triggers = ["launch_template"]  # Refresh when LT changes
  }

  lifecycle {
    ignore_changes = [desired_capacity]  # Don't drift if manually scaled
  }
}
##########################################################################
#Cpu Scaling Logic
##########################################################################
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  count                  = var.enable_ami_rollout ? 0 : 1
  name                   = "cpu-70-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}
##########################################################################
#Memory Scaling Logic
##########################################################################
resource "aws_autoscaling_policy" "memory_scale_out" {
  count                  = var.enable_ami_rollout ? 0 : 1
  name                   = "memory-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  step_adjustment {
    scaling_adjustment = 1
  }
}
