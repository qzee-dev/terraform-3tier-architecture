# VPC & Networking Outputs
output "vpc_id" {
  value       = module.networking.vpc_id
  description = "VPC ID for compute layer"
}

output "vpc_cidr" {
  value = module.networking.vpc_cidr
}

output "subnet1_id" {
  value       = module.networking.subnet1_id
  description = "Public subnet 1a ID"
}

output "subnet2_id" {
  value       = module.networking.subnet2_id
  description = "Public subnet 1b ID"
}

output "subnet3_id" {
  value = module.networking.subnet3_id
  description = "Private subnet 1a (app) ID"
}

output "subnet4_id" {
  value = module.networking.subnet4_id
  description = "Private subnet 1b (database) ID"
}

output "private_subnet_id" {
  value = module.networking.private_subnet_id
}

# ALB & Target Group Outputs
output "alb_dns_name" {
  value       = module.networking.alb_dns_name
  description = "ALB DNS name for accessing application"
}

output "alb_arn" {
  value = module.networking.alb_arn
}

output "alb_arn_suffix" {
  value = module.networking.app_lb_arn_suffix
}

output "app_tg_arn" {
  value       = module.networking.app_tg_arn
  description = "ALB Target Group ARN for compute layer"
}

output "app_tg_arn_suffix" {
  value = module.networking.app_tg_arn_suffix
}

# Security Group Outputs
output "ec2_sg_id" {
  value       = module.networking.ec2_sg_id
  description = "EC2 security group ID"
}

output "lambda_sg_id" {
  value = module.networking.lambda_sg_id
}

# IAM Outputs
output "iam_profile_name" {
  value       = module.iam.ec2_rds_secrets_profile_name
  description = "IAM instance profile for EC2 (RDS + Secrets access)"
}

# Storage Outputs
output "rds_endpoint" {
  value       = module.storage.rds_endpoint
  description = "RDS database endpoint"
}

output "rds_port" {
  value = module.storage.rds_port
}

output "s3_bucket_name" {
  value       = module.storage.s3_bucket_name
  description = "S3 bucket for ALB logs"
}

# Summary Output
output "foundation_summary" {
  value = {
    environment  = var.environment
    region       = var.aws_region
    vpc_id       = module.networking.vpc_id
    alb_endpoint = module.networking.alb_dns_name
    rds_endpoint = module.storage.rds_endpoint
  }
  description = "Summary of foundation resources"
}
