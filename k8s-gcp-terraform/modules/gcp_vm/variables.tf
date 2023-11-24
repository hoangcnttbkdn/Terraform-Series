variable "project_name" {
  type        = string
  description = "The GCP project name"
}

variable "environment" {
  type        = string
  description = "The project environment"
}

variable "region" {
  type        = string
  description = "The GCP region that infrastructure deploy in"
}

variable "zone" {
  type        = string
  description = "The GCP region availability zone"
}

variable "subnetwork" {
  type        = string
  description = "The object or self link for the subnet created in the parent module"
}

variable "name" {
  type        = string
  description = "The virtual machine name"
}

variable "instance_count" {
  type        = number
  description = "The number of instance you want to create"
  default     = 1
}
variable "disk_boot_size" {
  type        = number
  description = "The size for OS boot volume"
  default     = 20
}

variable "image" {
  type        = string
  description = "The GCP image"
  default     = "ubuntu-os-cloud/ubuntu-2004-focal-v20220712"
}

variable "machine_type" {
  type        = string
  description = "The virtual machine type"
  default     = "e2-small"
}

variable "network_ip" {
  type        = string
  description = "The network ip"
  default     = ""
}

variable "external_ip" {
  type        = string
  description = "The external ip"
  default     = ""
}

variable "username" {
  type        = string
  description = "The ssh user"
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "The ssh public key"
  default     = ""
}

variable "startup_script" {
  type        = string
  description = "The startup script when launching the instance"
  default     = ""
}

variable "tags" {
  type        = list(string)
  description = "The instance tag"
  default     = []
}