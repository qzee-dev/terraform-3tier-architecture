# Compute Layer: EC2 + Auto Scaling Group
# This is deployed AFTER foundation
# AMI changes trigger rolling refresh (handled by _ami-rollout layer)

module "compute" {
  source = "../modules/compute"

  # Reference foundation outputs via locals
  subnet1_id         = local.subnet1_id
  subnet2_id         = local.subnet2_id
  app_tg_arn         = local.app_tg_arn
  ec2_sg_id          = local.ec2_sg_id
  iam_profile_name   = local.iam_profile_name

  # Compute-specific variables
  instance_type1     = var.ec2_instance_type
  new_ami_id         = var.ec2_instance_ami_id
  existing_asg_name  = "web-asg"
  enable_ami_rollout = false  # Always false here (managed by _ami-rollout)

  environment  = var.environment
  project_name = var.project_name
}
