# 1. ALB DNS Name (Entry point)
output "alb_dns_name" {
  value = module.networking.alb_dns_name
}
# Output: app-alb-1234567890.us-east-1.elb.amazonaws.com
# Usage:  curl http://app-alb-1234567890.us-east-1.elb.amazonaws.com


# 2. S3 Bucket Name (Log storage)
output "s3_bucket_name" {
  value = module.storage.s3_bucket_name
}
# Output: test-bucket-1-qzee-project
# Usage:  aws s3 ls s3://test-bucket-1-qzee-project/


# 3. VPC ID (Infrastructure identifier)
output "vpc_id" {
  value = module.networking.vpc_id
}
# Output: vpc-0123456789abcdef0
# Usage:  Refer in other Terraform modules


# 4. ASG Instance Private IPs (Debugging)
output "asg_private_ips" {
  value = [] # Placeholder, as data source not defined
}
# Output: ["10.0.0.1", "10.0.0.2"]
# Usage:  SSH into instances via bastion host


# 5. RDS Endpoint (Database connection)
output "rds_endpoint" {
  value = module.storage.rds_endpoint
}
# Output: mydb.c9akciq32.us-east-1.rds.amazonaws.com:3306
# Usage:  Application connection string
