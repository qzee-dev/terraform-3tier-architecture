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

variable "private_subnet_id" {
  description = "Private subnet ID for lambda"
  type        = string
}

variable "lambda_sg_id" {
  description = "Security group ID for lambda"
  type        = string
}