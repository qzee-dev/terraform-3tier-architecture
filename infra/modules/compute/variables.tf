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

variable "instance_type1" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "new_ami_id" {
  description = "AMI ID for new instances"
  type        = string
  default     = "ami-0c02fb55956c7d31"
}

variable "existing_asg_name" {
  description = "Name of existing Auto Scaling Group for rollout"
  type        = string
  default     = "web-asg"
}

variable "enable_ami_rollout" {
  description = "Enable AMI rollout mode with instance refresh"
  type        = bool
  default     = false
}


variable "enable_ami_rollout" {
  description = "Enable AMI rollout mode with instance refresh"
  type        = bool
  default     = false
}

variable "new_ami_id" {
  description = "New AMI ID to deploy during rollout"
  type        = string
  default     = null  # Must be explicitly set during rollout
  
  validation {
    condition     = var.new_ami_id == null || can(regex("^ami-", var.new_ami_id))
    error_message = "new_ami_id must be a valid AMI ID (ami-xxxxxxxx) or null."
  }
}

variable "rollout_min_healthy_percentage" {
  description = "Minimum healthy percentage during rollout (0-100)"
  type        = number
  default     = 66
  
  validation {
    condition     = var.rollout_min_healthy_percentage >= 0 && var.rollout_min_healthy_percentage <= 100
    error_message = "Must be between 0 and 100."
  }
}

variable "rollout_instance_warmup" {
  description = "Instance warmup time in seconds (time before instance counts as healthy)"
  type        = number
  default     = 120
}
