output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket1.bucket
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "asg_private_ips" {
  value = [for i in data.aws_instance.asg_instance_ips : i.private_ip]
}
