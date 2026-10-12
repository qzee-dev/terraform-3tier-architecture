variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ec2_instance_ami_id" {
  description = "AMI ID for initial EC2 instances (first version)"
  type        = string
  default     = "ami-0c02fb55956c7d31"

  validation {
    condition     = can(regex("^ami-", var.ec2_instance_ami_id))
    error_message = "AMI ID must start with 'ami-'"
  }
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "qzee-demo"
}
