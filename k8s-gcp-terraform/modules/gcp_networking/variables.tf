variable "project_name" {
  type        = string
  description = "The project name"
}

variable "project" {
  type        = string
  description = "The project id"
}

variable "environment" {
  type        = string
  description = "The project environment"
}

variable "region" {
  type        = string
  description = "The GCP region that infrastructure deploy in"
}

variable "public_cidr_range" {
  type        = list(string)
  description = "The public subnetwork cidr"
}

variable "private_cidr_range" {
  type        = list(string)
  description = "The private subnetwork cidr"
  default     = []
}