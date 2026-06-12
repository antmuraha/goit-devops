variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for EKS nodes"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the Node Group"
  type        = number
  default     = 2
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}