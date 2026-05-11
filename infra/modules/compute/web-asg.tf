resource "aws_autoscaling_group" "web_asg" {
  count              = var.enable_ami_rollout ? 0 : 1
  name               = "web-asg"
  min_size           = 2
  max_size           = 4
  desired_capacity   = 2
  vpc_zone_identifier = [
    var.subnet1_id,
    var.subnet2_id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.app_tg_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 30
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }
}
##########################################################################
#Cpu Scaling Logic
##########################################################################
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  count                  = var.enable_ami_rollout ? 0 : 1
  name                   = "cpu-70-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_asg[0].name
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
  autoscaling_group_name = aws_autoscaling_group.web_asg[0].name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  step_adjustment {
    scaling_adjustment = 1
  }
}
