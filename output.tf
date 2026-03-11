output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.webserver1.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket1.bucket
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "ec2_private_ip" {
  value = aws_instance.webserver1.private_ip
}
