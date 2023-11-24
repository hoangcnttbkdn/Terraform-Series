variable "project_id" {
  type        = string
  description = "Project ID"
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment name"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Region for this infrastructure"
  default     = "asia-southeast1"
}

variable "credentials" {
  type        = string
  description = "The IAM credential file"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "The project name"
}

variable "username" {
  type        = string
  description = "username - use to ssh to vm"
}

variable "public_cidr_range" {
  type        = list(string)
  description = "List of internal ip for public subnet work"
  default     = ["10.0.1.0/24"]
}

variable "private_cidr_range" {
  type        = list(string)
  description = "List if internal ip for private subnet work"
  default     = ["10.0.16.0/20"]
}

/* variable "node_group" {
  type = list(object({
    node_name    = string
    count        = number
    machine_type = string
  }))
  description = "A list of worker node"
} */