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
