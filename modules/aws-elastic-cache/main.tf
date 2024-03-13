locals {
  name = "${var.project_name}-${var.environment}-${var.name}"
}

module "redis_sg" {
  source       = "../aws-security-group"
  name         = "${local.name}-redis-sg"
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = var.vpc_id

  ingress_rules = [{
    port        = 22
    cidr_blocks = ["0.0.0.0/0"]
  }]
  tags = var.tags
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${local.name}-${var.name}-redis"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.instance_type
  num_cache_nodes      = "1"
  parameter_group_name = var.parameter_group_name
  port                 = "6379"
  subnet_group_name    = var.private_subnet_ids
  security_group_ids   = module.redis_sg[*].security_group.name

  tags = merge(
    var.tags,
    {
      "Name" : "AWS Elastic Cache"
    }
  )
}