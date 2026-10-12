# 🚀 AMI ROLLOUT LAYER
# This layer ONLY handles application version deployments
# Foundation (networking, storage) and base compute (ASG) are UNTOUCHED
# 
# Each version update:
#   1. Creates new launch template with new AMI
#   2. Updates ASG to use new template
#   3. Triggers rolling instance refresh (zero downtime)
#   4. Automatic rollback if health checks fail

# ✅ Step 1: Create new launch template version with new AMI
resource "aws_launch_template" "web_lt_new_version" {
  name_prefix   = "webserver-v${replace(var.app_version, ".", "-")}-"
  image_id      = var.new_ami_id  # ← Only thing that changes
  instance_type = var.instance_type
  key_name      = data.aws_launch_template.current.key_name

  iam_instance_profile {
    name = data.aws_launch_template.current.iam_instance_profile[0].name
  }

  vpc_security_group_ids = data.aws_launch_template.current.vpc_security_group_ids
  ebs_optimized          = data.aws_launch_template.current.ebs_optimized

  monitoring {
    enabled = true
  }

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
      Name              = "webserver-asg"
      Environment       = var.environment
      "app-version"     = var.app_version
      "deployment-time" = timestamp()
    }
  }

  user_data = base64encode(data.aws_launch_template.current.user_data_base64 != null ? data.aws_launch_template.current.user_data_base64 : "")

  lifecycle {
    create_before_destroy = true
  }
}

# ✅ Step 2: Update ASG with new launch template (triggers rolling refresh)
resource "aws_autoscaling_group" "web_asg_updated" {
  name = local.web_asg_name

  # Use new launch template → triggers refresh
  launch_template {
    id      = aws_launch_template.web_lt_new_version.id
    version = "$Latest"
  }

  # Keep existing capacity settings from current ASG
  min_size            = data.aws_autoscaling_group.current.min_size
  max_size            = data.aws_autoscaling_group.current.max_size
  desired_capacity    = data.aws_autoscaling_group.current.desired_capacity
  vpc_zone_identifier = data.aws_autoscaling_group.current.vpc_zone_identifier

  # Target group from foundation
  target_group_arns = [local.app_tg_arn]

  # Health check settings
  health_check_type           = "ELB"
  health_check_grace_period   = 120
  termination_policies        = ["OldestInstance"]
  force_delete                = false
  enable_capacity_rebalance   = true

  # 🎯 ROLLING INSTANCE REFRESH - Zero Downtime Deployment
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 66       # Keep 66% healthy (2/3 or 2/2 instances)
      max_healthy_percentage = 150      # Allow temp over-capacity (3 instances)
      instance_warmup        = 120      # Wait 2 min for health checks
      skip_matching          = false    # Force replacement even if config same
      auto_rollback          = true     # Auto-rollback on health check failure
      checkpoint_delay       = 300      # 5 min between rollback checkpoints
      checkpoint_percentage  = 10       # Check every 10% of instances
    }

    triggers = ["launch_template"]  # Refresh when LT changes
  }

  tag {
    key                 = "Name"
    value               = "webserver-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "managed-by"
    value               = "terraform-ami-rollout"
    propagate_at_launch = true
  }

  tag {
    key                 = "app-version"
    value               = var.app_version
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]  # Don't drift on manual scaling
  }

  depends_on = [aws_launch_template.web_lt_new_version]
}

# ✅ Step 3: Output deployment status
output "deployment_status" {
  value = {
    asg_name               = aws_autoscaling_group.web_asg_updated.name
    launch_template_id     = aws_launch_template.web_lt_new_version.id
    launch_template_version = aws_launch_template.web_lt_new_version.latest_version_number
    new_ami_id             = var.new_ami_id
    app_version            = var.app_version
    deployment_timestamp   = timestamp()
    refresh_triggered      = true
  }
  description = "Status of AMI rollout deployment"
}

output "instance_refresh_details" {
  value = {
    strategy               = aws_autoscaling_group.web_asg_updated.instance_refresh[0].strategy
    min_healthy_percentage = aws_autoscaling_group.web_asg_updated.instance_refresh[0].preferences[0].min_healthy_percentage
    auto_rollback_enabled  = aws_autoscaling_group.web_asg_updated.instance_refresh[0].preferences[0].auto_rollback
  }
}
