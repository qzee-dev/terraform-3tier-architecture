output "web_asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "memory_scale_out_policy_arn" {
  value = aws_autoscaling_policy.memory_scale_out.arn
}