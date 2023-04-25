# Backend s3 variables
variable "backend_s3_bucket" {
  description = "Bucket name where to save backend terraform of project"
  type        = string
}

variable "backend_s3_key" {
  description = "state file name"
  type        = string
}

variable "backend_s3_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "backend_s3_role_arn" {
  type = string
}

variable "backend_s3_dynamodb_table" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

# Network
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
