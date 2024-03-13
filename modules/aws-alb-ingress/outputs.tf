# output "helm_release_metadata" {
#   description = "Helm release attributes"
#   value       = try(helm_release.this.metadata, {})
# }

output "iam_role_attributes" {
  description = "IAM role atributes"
  value       = try(aws_iam_role.this, {})
}