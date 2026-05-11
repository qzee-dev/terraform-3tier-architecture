module "networking" {
  source = "./modules/networking"

  alb_certificate_arn = var.alb_certificate_arn
}

module "storage" {
  source = "./modules/storage"

  vpc_id      = module.networking.vpc_id
  subnet3_id  = module.networking.subnet3_id
  subnet4_id  = module.networking.subnet4_id
  db_password = var.db_password
}

module "iam" {
  source            = "./modules/iam"
  private_subnet_id = module.networking.private_subnet_id
  lambda_sg_id      = module.networking.lambda_sg_id
}

module "compute" {
  source = "./modules/compute"

  subnet1_id         = module.networking.subnet1_id
  subnet2_id         = module.networking.subnet2_id
  app_tg_arn         = module.networking.app_tg_arn
  ec2_sg_id          = module.networking.ec2_sg_id
  iam_profile_name   = module.iam.ec2_rds_secrets_profile_name
  instance_type1     = var.ec2_instance_type
  new_ami_id         = var.ec2_instance_ami_id
  existing_asg_name  = "web-asg"
  enable_ami_rollout = false
}

module "monitoring" {
  source = "./modules/monitoring"

  web_asg_name                = module.compute.web_asg_name
  memory_scale_out_policy_arn = module.compute.memory_scale_out_policy_arn
  app_lb_arn_suffix           = module.networking.app_lb_arn_suffix
  app_tg_arn_suffix           = module.networking.app_tg_arn_suffix
  environment                 = var.environment
  project_name                = var.project_name
}

