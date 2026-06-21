variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "monitoring_namespace" {
  description = "The namespace for monitoring resources"
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_password" {
  description = "The admin password for Grafana"
  type        = string
  sensitive   = true
}