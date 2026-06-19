
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