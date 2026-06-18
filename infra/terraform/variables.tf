variable "jenkins_admin_username" {
  type    = string
  default = "admin"
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "ecr_repository_name" {
  type    = string
  default = "lesson-8-9-ecr"
}