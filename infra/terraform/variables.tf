variable "jenkins_admin_username" {
  type    = string
  default = "admin"
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
  default   = "ATTENTION: Change this password in production!"
}

variable "ecr_repository_name" {
  type    = string
  default = "lesson-8-9-ecr"
}

variable "rds_name" {
  description = "Name of the RDS instance or Aurora cluster"
  type        = string
}

variable "rds_db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "mydb"
}

variable "rds_use_aurora" {
  description = "Boolean to determine whether to use Aurora or standard RDS."
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "Database engine to use (e.g., postgres, aurora-postgresql)."
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "Version of the database engine."
  type        = string
  default     = "18.3"
}

variable "rds_allocated_storage" {
  description = "Allocated storage size in GB for the RDS instance."
  type        = number
  default     = 5
}

variable "rds_aurora_instance_count" {
  description = "Number of instances in the Aurora cluster (1 primary + N replicas)."
  type        = number
  default     = 2
}

variable "rds_instance_class" {
  description = "Instance class for the RDS instance or Aurora cluster."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_multi_az" {
  description = "Boolean to determine whether to enable Multi-AZ deployment."
  type        = bool
  default     = false
}