variable "subnet1_id" {
  description = "ID of subnet1"
  type        = string
}

variable "subnet2_id" {
  description = "ID of subnet2"
  type        = string
}

variable "app_tg_arn" {
  description = "ARN of the app target group"
  type        = string
}

variable "ec2_sg_id" {
  description = "ID of the EC2 security group"
  type        = string
}

variable "iam_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}