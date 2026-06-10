
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

###### S3 and DynamoDB Outputs ######

output "s3_bucket_name" {
  value = module.s3_backend.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3_backend.bucket_arn
}

output "bucket_url" {
  value = module.s3_backend.bucket_url
}

output "dynamodb_table_name" {
  value = module.s3_backend.dynamodb_table_name
}

###### ECR Outputs ######

output "ecr_repository_url" {
  value = module.ecr.repository_url
}