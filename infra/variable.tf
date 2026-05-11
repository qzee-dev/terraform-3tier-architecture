variable "vpc_cidr_block" {
  default = "this is the value for block ip"
}

variable "public_subnet_1a_cidr" {
  default = "this is subnet1 value"

}

variable "public_subnet_1b_cidr" {
  default = "value  for subnet2"

}
variable "private_subnet_1a_cidr" {
  default = "value of subnet3"

}

variable "private_subnet_1b_cidr" {
  default = "value for subnet4"

}

variable "ec2_instance_ami_id" {
  default = "value for ec2 ami"
}

variable "ec2_instance_type" {
  default = "value for instance_type"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project identifier for naming"
  type        = string
  default     = "qzee-demo"
}

variable "alb_certificate_arn" {
  description = "ARN of the ACM certificate used by the ALB HTTPS listener"
  type        = string
  default     = "arn:aws:acm:us-east-1:123456789012:certificate/PLACEHOLDER"
}



