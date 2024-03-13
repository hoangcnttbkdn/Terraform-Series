locals {
  naming_rules = yamldecode(var.naming_rules)
  # Validate required inputs
  valid_environment = can(local.naming_rules.environment.allowed_values[var.environment]) ? null : file("ERROR: invalid input value for environment")
  valid_region      = can(local.naming_rules.awsRegion.allowed_values[var.region]) ? null : file("ERROR: invalid input value for region")
}