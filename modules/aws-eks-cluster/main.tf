# resource "aws_cloudwatch_log_group" "default" {
#   count             = length(var.enabled_cluster_log_types) > 0 ? 1 : 0
#   name              = local.cloudwatch_log_group_name
#   retention_in_days = var.cluster_log_retention_period
#   kms_key_id        = var.cloudwatch_log_group_kms_key_id
#   tags = merge(
#     var.tags,
#     {
#       "Name" : "${local.cloudwatch_log_group_name}",
#       "Description" : "EKS Cluster Log"
#   })
# }

resource "aws_kms_key" "cluster" {
  count                   = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
  deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
  policy                  = var.cluster_encryption_config_kms_key_policy
  tags = merge({
    "Description" : "EKS Cluster ${var.cluster_name} Encryption Config KMS Key on ${var.environment} environment"
    "Name" : "${local.name_default}-kms-key"
    },

  var.tags)
}

resource "aws_kms_alias" "cluster" {
  count         = var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  name          = format("alias/%v", "${local.name_default}-${var.cluster_name}-key")
  target_key_id = one(aws_kms_key.cluster[*].key_id)
}

resource "aws_eks_cluster" "default" {
  #bridgecrew:skip=BC_AWS_KUBERNETES_1:Allow permissive security group for public access, difficult to restrict without a VPN
  #bridgecrew:skip=BC_AWS_KUBERNETES_4:Let user decide on control plane logging, not necessary in non-production environments
  name                      = "${local.name_default}-${var.cluster_name}-eks-cluster"
  tags                      = var.tags
  role_arn                  = local.eks_service_role_arn
  version                   = var.kube_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.cluster[0].arn
    }
  }

  vpc_config {
    security_group_ids      = var.create_security_group ? compact(concat(var.associated_security_group_ids, [one(aws_security_group.default[*].id)])) : var.associated_security_group_ids
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    #bridgecrew:skip=BC_AWS_KUBERNETES_2:Let user decide on public access
    endpoint_public_access = var.endpoint_public_access
    public_access_cidrs    = var.public_access_cidrs
  }

  dynamic "kubernetes_network_config" {
    for_each = local.use_ipv6 ? [] : compact([var.service_ipv4_cidr])
    content {
      service_ipv4_cidr = kubernetes_network_config.value
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = local.use_ipv6 ? [true] : []
    content {
      ip_family = "ipv6"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.amazon_eks_service_policy,
    aws_security_group.default,
    aws_security_group_rule.egress,
    # aws_security_group_rule.ingress_cidr_blocks,
    # aws_security_group_rule.ingress_security_groups,
    # aws_security_group_rule.ingress_workers,
    # aws_cloudwatch_log_group.default
  ]
}

data "tls_certificate" "cluster" {
  count = var.oidc_provider_enabled ? 1 : 0
  url   = one(aws_eks_cluster.default[*].identity.0.oidc.0.issuer)
}

resource "aws_iam_openid_connect_provider" "default" {
  count = var.oidc_provider_enabled ? 1 : 0
  url   = one(aws_eks_cluster.default[*].identity.0.oidc.0.issuer)
  tags  = var.tags

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [one(data.tls_certificate.cluster[*].certificates.0.sha1_fingerprint)]
}

resource "aws_eks_addon" "cluster" {
  for_each = {
    for addon in var.addons :
    addon.addon_name => addon
  }

  cluster_name             = one(aws_eks_cluster.default[*].name)
  addon_name               = each.key
  addon_version            = lookup(each.value, "addon_version", null)
  resolve_conflicts        = lookup(each.value, "resolve_conflicts", null)
  service_account_role_arn = lookup(each.value, "service_account_role_arn", null)

  tags = var.tags
}