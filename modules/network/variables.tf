variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet" {
  type = list(string)
}

variable "public_subnet" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "create_nat_gateway" {
  type    = bool
  default = false
}
