variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "Tag mutability setting for the ECR repository (MUTABLE or IMMUTABLE)"
}