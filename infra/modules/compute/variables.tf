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