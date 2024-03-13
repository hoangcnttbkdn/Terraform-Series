# -----------------------------------------------------------------------
# Rules for EKS-managed Security Group
# -----------------------------------------------------------------------

resource "aws_security_group_rule" "managed_ingress_security_groups" {
  count = length(local.allowed_security_group_ids)

  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = local.allowed_security_group_ids[count.index]
  security_group_id        = one(aws_eks_cluster.default[*].vpc_config.0.cluster_security_group_id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "managed_ingress_cidr_blocks" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = one(aws_eks_cluster.default[*].vpc_config.0.cluster_security_group_id)
  type              = "ingress"
}

# -----------------------------------------------------------------------
# DEPRECATED: Additional Security Group
# -----------------------------------------------------------------------

locals {
  create_security_group = var.create_security_group
}

resource "aws_security_group" "default" {
  count       = local.create_security_group ? 1 : 0
  name        = "${local.name_default}-eks-sg"
  description = "Security Group for EKS cluster"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "egress" {
  count = local.create_security_group ? 1 : 0

  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.default[*].id)
  type              = "egress"
}

# resource "aws_security_group_rule" "ingress_workers" {
#   count = local.create_security_group ? length(var.allowed_security_group_ids) : 0

#   description              = "Allow the cluster to receive communication from the worker nodes"
#   from_port                = 0
#   to_port                  = 65535
#   protocol                 = "-1"
#   source_security_group_id = var.allowed_security_group_ids[count.index]
#   security_group_id        = one(aws_security_group.default[*].id)
#   type                     = "ingress"
# }

# resource "aws_security_group_rule" "ingress_security_groups" {
#   count = local.create_security_group ? length(local.allowed_security_group_ids) : 0

#   description              = "Allow inbound traffic from existing Security Groups"
#   from_port                = 0
#   to_port                  = 65535
#   protocol                 = "-1"
#   source_security_group_id = local.allowed_security_group_ids[count.index]
#   security_group_id        = one(aws_security_group.default[*].id)
#   type                     = "ingress"
# }

# resource "aws_security_group_rule" "ingress_cidr_blocks" {
#   count = local.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

#   description       = "Allow inbound traffic from CIDR blocks"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "-1"
#   cidr_blocks       = var.allowed_cidr_blocks
#   security_group_id = one(aws_security_group.default[*].id)
#   type              = "ingress"
# }

# resource "aws_security_group_rule" "custom_ingress_rules" {

#   for_each = { for sg_rule in var.custom_ingress_rules : sg_rule.source_security_group_id => sg_rule }

#   description              = each.value.description
#   from_port                = each.value.from_port
#   to_port                  = each.value.to_port
#   protocol                 = each.value.protocol
#   source_security_group_id = each.value.source_security_group_id
#   security_group_id        = one(aws_eks_cluster.default[*].vpc_config.0.cluster_security_group_id)
#   type                     = "ingress"
# }