# Foundation Layer: Networking + Storage (Deployed Once)
# Changes here are RARE. Most updates happen in _compute or _ami-rollout

module "networking" {
  source = "../modules/networking"

  vpc_cidr_block         = var.vpc_cidr_block
  public_subnet_1a_cidr  = var.public_subnet_1a_cidr
  public_subnet_1b_cidr  = var.public_subnet_1b_cidr
  private_subnet_1a_cidr = var.private_subnet_1a_cidr
  private_subnet_1b_cidr = var.private_subnet_1b_cidr
  alb_certificate_arn    = var.alb_certificate_arn
  environment            = var.environment
  project_name           = var.project_name
}

module "storage" {
  source = "../modules/storage"

  vpc_id       = module.networking.vpc_id
  subnet3_id   = module.networking.subnet3_id
  subnet4_id   = module.networking.subnet4_id
  db_password  = var.db_password
  environment  = var.environment
  project_name = var.project_name
}

module "iam" {
  source = "../modules/iam"

  private_subnet_id = module.networking.private_subnet_id
  lambda_sg_id      = module.networking.lambda_sg_id
  environment       = var.environment
  project_name      = var.project_name
}

module "monitoring" {
  source = "../modules/monitoring"

  app_lb_arn_suffix = module.networking.app_lb_arn_suffix
  app_tg_arn_suffix = module.networking.app_tg_arn_suffix
  environment       = var.environment
  project_name      = var.project_name
}
