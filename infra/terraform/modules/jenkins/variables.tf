variable "kubeconfig" {
  description = "Path to the kubeconfig file for accessing the Kubernetes cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "jenkins_admin_username" {
  description = "Jenkins admin username"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "oidc_provider_arn" {
  type        = string
  description = "EKS OIDC provider ARN for IRSA"
}

variable "oidc_provider_url" {
  type        = string
  description = "EKS OIDC provider URL (without https:// used in condition keys)"
}

variable "ecr_registry" {
  description = "AWS ECR registry URL"
  type        = string
}

variable "git_repository_url" {
  description = "Git repository URL used by Jenkins pipeline"
  type        = string
}