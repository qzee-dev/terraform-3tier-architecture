output "web_asg_name" {
  value = var.enable_ami_rollout ? aws_autoscaling_group.existing_asg[0].name : aws_autoscaling_group.web_asg[0].name
}

output "memory_scale_out_policy_arn" {
  value = var.enable_ami_rollout ? "" : aws_autoscaling_policy.memory_scale_out[0].arn
}