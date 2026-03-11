#Security Group for EC2 (ASG)
resource "aws_security_group" "asg_sg" {
  name        = "asg-sg"
  description = "Security group for ASG EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Allow traffic from ALB only
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # only allow ALB
  }

  # Allow all outbound traffic (for updates, Docker image pulls, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg-sg"
  }
}

#Launch Template for EC2
resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template-"
  image_id      = "ami-xxxxxxxx"  # Replace with Amazon Linux 2 AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-instance"
    }
  }
}
#Auto Scaling Group (Min 2, Max 6)
resource "aws_autoscaling_group" "web_asg" {
  name               = "web-asg"
  min_size           = 2
  max_size           = 6
  desired_capacity   = 2

  vpc_zone_identifier = [
    aws_subnet.subnet3.id,  # private subnet 1
    aws_subnet.subnet4.id   # private subnet 2
  ]

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60
}

#Optional: Auto Scaling Policy (CPU-Based)# triggerd point
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}
