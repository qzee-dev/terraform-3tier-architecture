
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "alb_logs_bucket_id" {
  description = "ID of the ALB logs S3 bucket"
  type        = string
  default     = "my-alb-logs-bucket"
}

variable "alb_certificate_arn" {
  description = "ARN of the ACM certificate used by the ALB HTTPS listener"
  type        = string
  default     = "arn:aws:acm:us-east-1:123456789012:certificate/PLACEHOLDER"
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet 1a"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet 1b"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet 1a"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for private subnet 1b"
  type        = string
  default     = "10.0.3.0/24"
}
