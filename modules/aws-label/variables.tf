variable "naming_rules" {
  description = "Naming conventions json file"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment to develop project"
  type        = string
}

variable "region" {
  description = "AWS location"
  type        = string
}

variable "additional_tags" {
  type        = map(string)
  description = "A map of additional tags to add to the tags output"
  default     = {}
}