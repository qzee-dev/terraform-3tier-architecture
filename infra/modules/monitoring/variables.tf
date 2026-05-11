variable "web_asg_name" {
  description = "Name of the web ASG"
  type        = string
}

variable "memory_scale_out_policy_arn" {
  description = "ARN of the memory scale out policy"
  type        = string
}

variable "app_lb_arn_suffix" {
  description = "ARN suffix of the app load balancer"
  type        = string
}

variable "app_tg_arn_suffix" {
  description = "ARN suffix of the app target group"
  type        = string
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