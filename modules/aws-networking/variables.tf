#------------------------------------------------------------------------------
# Project
#------------------------------------------------------------------------------
variable "project_name" {
  description = "Name of project"
}

#------------------------------------------------------------------------------
# Environment
#------------------------------------------------------------------------------
variable "environment" {
  type        = string
  description = "AWS Environment"
}

#------------------------------------------------------------------------------
# AWS Region
#------------------------------------------------------------------------------
variable "region" {
  type    = string
  default = "ap-southeast-1"
}

#------------------------------------------------------------------------------
# AWS Virtual Private Network
#------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "AWS VPC CIDR Block"
  type        = string
}

variable "create_eks" {
  description = "Create EKS or not"
  type        = bool
  default     = false
}


#------------------------------------------------------------------------------
# AWS Subnets
#------------------------------------------------------------------------------
variable "availability_zones" {
  type        = list(any)
  description = "List of availability zones to be used by subnets"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "Auto assign Public IP when instance start launch"
}
variable "public_subnets_cidrs_per_availability_zone" {
  type        = list(any)
  description = "List of CIDRs to use on each availability zone for public subnets"
}

variable "private_subnets_cidrs_per_availability_zone" {
  type        = list(any)
  description = "List of CIDRs to use on each availability zone for private subnets"
}

variable "single_nat" {
  type        = bool
  default     = false
  description = "Enable single NAT Gateway"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to each resource"
}