module "storage" {
  source = "../storage"

  vpc_id     = module.networking.vpc_id
  subnet3_id = module.networking.subnet3_id
  subnet4_id = module.networking.subnet4_id
}

module "networking" {
  source = "../networking"

  alb_logs_bucket_id = module.storage.alb_logs_bucket_id
}

module "iam" {
  source = "../iam"
}

module "compute" {
  source = "../compute"

  subnet1_id       = module.networking.subnet1_id
  subnet2_id       = module.networking.subnet2_id
  app_tg_arn       = module.networking.app_tg_arn
  ec2_sg_id        = module.networking.ec2_sg_id
  iam_profile_name = module.iam.ec2_rds_secrets_profile_name
}

module "monitoring" {
  source = "../monitoring"

  web_asg_name                = module.compute.web_asg_name
  memory_scale_out_policy_arn = module.compute.memory_scale_out_policy_arn
  app_lb_arn_suffix           = module.networking.app_lb_arn_suffix
  app_tg_arn_suffix           = module.networking.app_tg_arn_suffix
}

