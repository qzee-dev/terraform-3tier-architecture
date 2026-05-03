/*
# 1️⃣ Launch Template (new version with baked AMI)
resource "aws_launch_template" "web" {
  name_prefix   = "web-ami-"
  image_id      = var.new_ami_id
  instance_type = "t3.micro"

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}

# 2️⃣ Use existing Auto Scaling Group
resource "aws_autoscaling_group" "existing_asg" {
  name = var.existing_asg_name

  # Use latest launch template version
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  # Rolling Instance Refresh
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 66    # safe for 2→3 instances
      instance_warmup        = 120
    }

    triggers = ["launch_template"]
  }
}

# 3️⃣ Optional: Temporary scale-up before rollout
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-before-refresh"
  autoscaling_group_name = var.existing_asg_name
  scaling_adjustment     = 1        # add 1 instance as safety buffer
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

# 4️⃣ Optional: Scale back down after refresh
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-after-refresh"
  autoscaling_group_name = var.existing_asg_name
  scaling_adjustment     = -1       # remove buffer instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

*\
