locals {
  name_default = "${var.project_name}-${var.environment}"
  use_ipv6     = var.kube_network_ipv6_enabled
  cluster_encryption_config = {
    resource = var.cluster_encryption_config_resources
    provider_key_arn = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? (
      one(aws_kms_key.cluster[*].arn)
    ) : var.cluster_encryption_config_kms_key_id
  }

  cloudwatch_log_group_name = "/aws/${var.project_name}/${var.environment}/eks/cluster/${var.cluster_name}"
}