output "web_asg_name" {
  value       = module.compute.web_asg_name
  description = "Auto Scaling Group name"
}

output "web_asg_arn" {
  value = module.compute.web_asg_arn
}

output "launch_template_id" {
  value       = module.compute.web_lt_id
  description = "Launch template ID (used by _ami-rollout)"
}

output "launch_template_latest_version" {
  value       = module.compute.web_lt_latest_version
  description = "Latest launch template version"
}

output "instances_ids" {
  value       = module.compute.instance_ids
  description = "EC2 instance IDs in ASG"
}

output "compute_summary" {
  value = {
    asg_name              = module.compute.web_asg_name
    launch_template_id    = module.compute.web_lt_id
    instance_type         = var.ec2_instance_type
    desired_capacity      = 2
    min_size              = 2
    max_size              = 4
  }
}
