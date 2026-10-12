output "new_launch_template_id" {
  value       = aws_launch_template.web_lt_new_version.id
  description = "ID of new launch template"
}

output "new_launch_template_version" {
  value       = aws_launch_template.web_lt_new_version.latest_version_number
  description = "Latest version number of launch template"
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg_updated.name
}

output "deployment_complete" {
  value = {
    asg_name        = aws_autoscaling_group.web_asg_updated.name
    app_version     = var.app_version
    ami_id          = var.new_ami_id
    timestamp       = timestamp()
    status          = "Rolling instance refresh initiated"
  }
}

output "rollback_instructions" {
  value = "To rollback: terraform apply -var='new_ami_id=<PREVIOUS_AMI_ID>' -var='app_version=<PREVIOUS_VERSION>'"
}
