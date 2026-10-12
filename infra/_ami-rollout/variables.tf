variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "new_ami_id" {
  type        = string
  description = "New AMI ID to deploy (e.g., ami-0a1b2c3d4e5f6g7h8)"

  validation {
    condition     = can(regex("^ami-[0-9a-f]{17}$|^ami-[0-9a-f]{8}$", var.new_ami_id))
    error_message = "new_ami_id must be a valid AMI ID format (ami-xxxxxxxx or ami-xxxxxxxxxxxxxxxxx)"
  }
}

variable "app_version" {
  type        = string
  description = "Application version tag (e.g., v1.0.0, v2.1.3)"
  default     = "v1.0.0"

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.app_version))
    error_message = "app_version must follow semantic versioning format: v1.0.0"
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
  default     = "prod"
}

variable "min_healthy_percentage" {
  type        = number
  description = "Minimum healthy percentage during rolling refresh"
  default     = 66

  validation {
    condition     = var.min_healthy_percentage >= 0 && var.min_healthy_percentage <= 100
    error_message = "min_healthy_percentage must be between 0 and 100"
  }
}

variable "max_healthy_percentage" {
  type        = number
  description = "Maximum healthy percentage during rolling refresh"
  default     = 150

  validation {
    condition     = var.max_healthy_percentage >= 100
    error_message = "max_healthy_percentage must be >= 100"
  }
}

variable "instance_warmup_seconds" {
  type        = number
  description = "Seconds to wait before considering instance healthy"
  default     = 120
}
