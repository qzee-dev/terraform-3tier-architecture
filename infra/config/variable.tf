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



