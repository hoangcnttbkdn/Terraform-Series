module "ssh_access" {
  source       = "../aws-security-group"
  name         = "${var.node_group_name}-ssh-ng"
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = data.aws_eks_cluster.this.vpc_config[0].vpc_id

  ingress_rules = [{
    port        = 22
    cidr_blocks = ["0.0.0.0/0", "192.168.0.0/24"]
  }]
  tags = var.tags
}