variable "jenkins_admin_username" {
  type    = string
  default = "admin"
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "lesson-8-9-eks"
}

variable "postgres_password" {
  sensitive = true
}

variable "django_replicas" {
  default = 2
}

variable "django_image_tag" {
  default = "latest"
}

variable "git_repository_url" {}

variable "ecr_repository_name" {
  type    = string
  default = "lesson-8-9-ecr"
}

variable "app_repo_name" {
  description = "Logical repository name for application (GitOps reference)"
  type        = string
}

variable "infra_repo_name" {
  description = "Logical repository name for infrastructure (GitOps reference)"
  type        = string
}