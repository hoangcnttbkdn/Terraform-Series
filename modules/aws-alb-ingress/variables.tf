variable "project_name" {
  description = "Project Name"
  type        = string
  default     = ""
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "environment" {
  description = "The environment that app is deployed"
  type        = string
}

variable "name" {
  description = "The name of all resources of alb"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to each resource"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EKS cluster"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.4.6"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "alb-controller"
  description = "Helm release name"
}
variable "helm_repo_url" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "Helm repository"
}

variable "namespace" {
  type        = string
  default     = "aws-lb-controller"
  description = "The K8s namespace in which the aws-load-balancer-controller service account has been created"
}

variable "service_account_name" {
  default     = "aws-load-balancer-controller"
  description = "The k8s aws-loab-balancer-controller service account name"
}

variable "irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account"
}

variable "irsa_role_name_prefix" {
  type        = string
  default     = "lb-controller"
  description = "The IRSA role name prefix for LB controller"
}

variable "irsa_policy_enabled" {
  type        = bool
  default     = true
  description = "Whether to create opinionated policy for LB controller, see https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/v2.4.0/docs/install/iam_policy.json"
}

variable "irsa_tags" {
  type        = map(string)
  default     = {}
  description = "IRSA resources tags"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}