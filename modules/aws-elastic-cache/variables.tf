variable "project_name" {
  description = "Project Name"
  type        = string
  default     = ""
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "environment" {
  description = "The environment that app is deployed"
  type        = string
}

variable "name" {
  type        = string
  description = "The Redis Cluster name"
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to each resource"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EKS cluster"
}

variable "private_subnet_ids" {
  type        = string
  description = "A list of subnet IDs to launch the redis cluster"
}

variable "engine_version" {
  type    = string
  default = "7.0"
}

variable "parameter_group_name" {
  type        = string
  default     = "default.redis7"
  description = "The redis cluster parameters"
}

variable "instance_type" {
  type        = string
  default     = "cache.t3.small"
  description = "The redis cluster instance type"
}
