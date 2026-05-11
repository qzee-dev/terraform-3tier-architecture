output "alb_logs_bucket_id" {
  value = aws_s3_bucket.alb_logs.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket1.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}