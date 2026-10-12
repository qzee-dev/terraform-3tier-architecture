# Fetch Compute Layer Outputs
data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    bucket         = "your-org-tfstate"
    key            = "compute/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

# Fetch Foundation Layer Outputs (for ALB target group)
data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket         = "your-org-tfstate"
    key            = "foundation/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

# Get current ASG from compute layer
data "aws_autoscaling_group" "current" {
  name = data.terraform_remote_state.compute.outputs.web_asg_name
}

# Get current launch template to copy configurations
data "aws_launch_template" "current" {
  id = data.terraform_remote_state.compute.outputs.launch_template_id
}

# Convert to locals for easy reference
locals {
  web_asg_name        = data.terraform_remote_state.compute.outputs.web_asg_name
  launch_template_id  = data.terraform_remote_state.compute.outputs.launch_template_id
  app_tg_arn          = data.terraform_remote_state.foundation.outputs.app_tg_arn
  subnet1_id          = data.terraform_remote_state.foundation.outputs.subnet1_id
  subnet2_id          = data.terraform_remote_state.foundation.outputs.subnet2_id
  ec2_sg_id           = data.terraform_remote_state.foundation.outputs.ec2_sg_id
  iam_profile_name    = data.terraform_remote_state.foundation.outputs.iam_profile_name
}
