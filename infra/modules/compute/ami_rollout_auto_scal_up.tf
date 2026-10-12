# infra/modules/compute/ami_rollout_auto_scal_up.tf
# ================================================

# 1️⃣ Create NEW launch template for rollout
resource "aws_launch_template" "web_lt_rollout" {
  count       = var.enable_ami_rollout ? 1 : 0
  name_prefix = "webserver-rollout-"
  image_id    = var.new_ami_id
  instance_type = var.instance_type1
  key_name    = "my-keypair-name"

  iam_instance_profile {
    name = var.iam_profile_name
  }

  vpc_security_group_ids = [var.ec2_sg_id]

  monitoring {
    enabled = true
  }

  ebs_optimized = true

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webserver-asg"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 2️⃣ Update existing ASG to use new launch template
resource "aws_autoscaling_group" "web_asg_rollout" {
  count = var.enable_ami_rollout ? 1 : 0

  name = aws_autoscaling_group.web_asg.name  # Reference the existing ASG name

  # ⚠️ IMPORTANT: Use AWS provider's import or data source pattern
  # This updates the existing ASG without recreating it
  launch_template {
    id      = aws_launch_template.web_lt_rollout[0].id
    version = "$Latest"
  }

  # Trigger instance refresh when launch template changes
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 66  # Safe for 2-4 instances
      max_healthy_percentage = 150  # Allow temporary over-capacity
      instance_warmup        = 120
      skip_matching          = false
      auto_rollback          = true
    }

    triggers = ["launch_template"]
  }

  lifecycle {
    ignore_changes = [
      launch_template[0].version,  # Let refresh manage version
      desired_capacity              # Preserve current capacity
    ]
  }

  depends_on = [
    aws_autoscaling_group.web_asg
  ]
}

# 3️⃣ Conditional scaling policies during rollout
resource "aws_autoscaling_policy" "scale_up_during_rollout" {
  count                  = var.enable_ami_rollout ? 1 : 0
  name                   = "scale-up-during-rollout"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

# 4️⃣ Output rollout status
output "ami_rollout_launch_template_id" {
  value       = try(aws_launch_template.web_lt_rollout[0].id, null)
  description = "Launch template ID used for AMI rollout"
}

output "ami_rollout_status" {
  value = var.enable_ami_rollout ? "ROLLOUT_ENABLED" : "NORMAL_MODE"
}

