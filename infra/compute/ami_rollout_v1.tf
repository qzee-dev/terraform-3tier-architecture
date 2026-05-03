/*
# Step 1: Launch Template (new version with baked AMI)
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

# Step 2: Trigger Instance Refresh on existing ASG
resource "aws_autoscaling_group" "existing_asg" {
  # IMPORTANT: Use the existing ASG name
  name                      = var.existing_asg_name

  # Refer to the latest launch template version
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50       # adjust depending on ASG size
      instance_warmup        = 120
    }

    triggers = ["launch_template"]
  }
}
*\

