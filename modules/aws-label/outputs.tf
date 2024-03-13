output "project_name" {
  value       = local.project_name
  description = "Project name"
}

output "region" {
  value       = local.region
  description = "AWS location"
}

output "environment" {
  value       = local.environment
  description = "Environment"
}

output "tags" {
  value       = local.tags
  description = "Map of tags with any global defaults appended"
}