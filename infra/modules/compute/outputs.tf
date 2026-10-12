output "web_asg_name" {
  value = var.enable_ami_rollout ? aws_autoscaling_group.existing_asg[0].name : aws_autoscaling_group.web_asg[0].name
}

output "memory_scale_out_policy_arn" {
  value = var.enable_ami_rollout ? "" : aws_autoscaling_policy.memory_scale_out[0].arn
}


# 4️⃣ Output rollout status
output "ami_rollout_launch_template_id" {
  value       = try(aws_launch_template.web_lt_rollout[0].id, null)
  description = "Launch template ID used for AMI rollout"
}

output "ami_rollout_status" {
  value = var.enable_ami_rollout ? "ROLLOUT_ENABLED" : "NORMAL_MODE"
}

