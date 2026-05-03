output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "subnet3_id" {
  value = aws_subnet.subnet3.id
}

output "subnet4_id" {
  value = aws_subnet.subnet4.id
}

output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "app_lb_arn_suffix" {
  value = aws_lb.app_alb.arn_suffix
}

output "app_tg_arn_suffix" {
  value = aws_lb_target_group.app_tg.arn_suffix
}