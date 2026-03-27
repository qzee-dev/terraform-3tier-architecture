
resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  health_check_type         = "ELB"
  health_check_grace_period = 30
  force_delete              = true

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }
}
