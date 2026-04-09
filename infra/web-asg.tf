resource "aws_autoscaling_group" "web_asg" {
  name               = "web-asg"
  min_size           = 2
  max_size           = 4
  desired_capacity   = 2
  vpc_zone_identifier = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

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
Cpu Scaling Logic
##########################################################################
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-70-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value       = 70
    scale_out_cooldown = 120
    scale_in_cooldown  = 300
  }
}
##########################################################################
Memory Scaling Logic
##########################################################################
resource "aws_autoscaling_policy" "memory_scale_out" {
  name                   = "memory-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300

  step_adjustment {
    scaling_adjustment = 1
  }
}
