variable "name" {
  description = "Name of the RDS instance or Aurora cluster"
  type        = string
}

variable "db_name" {
  type = string
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "aurora_instance_count" {
  type    = number
  default = 2 # 1 primary and 1 replica
}

variable "engine_version" {
  type    = string
  default = "18.3"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 5
}



variable "username" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "parameters" {
  type    = map(string)
  default = {}
}

variable "use_aurora" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "parameter_group_family_aurora" {
  type    = string
  default = "aurora-postgresql18"
}
variable "parameter_group_family_rds" {
  type    = string
  default = "postgres18"
}
