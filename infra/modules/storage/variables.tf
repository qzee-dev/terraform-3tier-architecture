variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet3_id" {
  description = "ID of subnet3"
  type        = string
}
variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}
variable "subnet4_id" {
  description = "ID of subnet4"
  type        = string
}