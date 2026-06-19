
###### VPC Outputs #######

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID of the main VPC"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "IDs of private subnets"
}

output "internet_gateway_id" {
  value       = module.vpc.internet_gateway_id
  description = "ID of the Internet Gateway"
}

output "public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "ID of the public route table"
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}

###### S3 Outputs ######

output "s3_bucket_name" {
  value = module.s3_backend.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3_backend.bucket_arn
}

output "bucket_url" {
  value = module.s3_backend.bucket_url
}

###### ECR Outputs ######

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

###### Jenkins Outputs ######

output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

output "jenkins_url" {
  description = "Public Jenkins URL (if exposed via LoadBalancer)"
  value       = module.jenkins.jenkins_url
}

output "argocd_url" {
  value = module.argo_cd.argocd_url
}

###### RDS Outputs ######
output "rds_name" {
  description = "Name of the RDS instance or Aurora cluster."
  value       = module.rds.rds_name
}

output "rds_db_name" {
  description = "Name of the initial database created in the RDS instance or Aurora cluster."
  value       = module.rds.rds_db_name
}

output "rds_reader_endpoint" {
  description = "Read-only endpoint for scaling read traffic (Aurora only). Null for standard RDS."
  value       = module.rds.rds_reader_endpoint
}

output "rds_port" {
  description = "Database port used by the engine (PostgreSQL/MySQL/etc)."
  value       = module.rds.rds_port
}

output "rds_instance_identifier" {
  description = "Identifier of the database instance or cluster."
  value       = module.rds.rds_instance_identifier
}

output "rds_engine" {
  description = "Database engine used (e.g. postgres, aurora-postgresql)."
  value       = module.rds.rds_engine
}

output "rds_security_group_id" {
  description = "Security Group ID attached to the database. Used for controlling inbound access."
  value       = module.rds.rds_security_group_id
}

output "rds_subnet_group" {
  description = "DB subnet group used for network placement (usually private subnets)."
  value       = module.rds.rds_subnet_group_name
}

output "rds_instance_id" {
  description = "Identifier of the database instance or cluster."
  value       = module.rds.rds_instance_identifier
}