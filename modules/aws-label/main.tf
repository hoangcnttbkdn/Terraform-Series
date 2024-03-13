locals {
  # Global Tags
  default_tags = {
    Terraform = "Yes"
    Provider  = "AWS"
  }

  # Project Name 
  project_name = lower(var.project_name)

  # AWS Region
  region = var.region

  # Environment
  environment = var.environment

  # Tagging metadata
  tags = merge(
    {
      "Project Name" = lower(var.project_name)
      "Environment"  = local.naming_rules.environment.allowed_values[var.environment]
      "Region"       = local.naming_rules.awsRegion.allowed_values[var.region]
    },
    var.additional_tags,
    local.default_tags,
  )
}