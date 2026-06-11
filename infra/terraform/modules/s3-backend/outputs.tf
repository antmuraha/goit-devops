output "bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Name of the S3 bucket storing Terraform state"
}

output "bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "ARN of the Terraform state S3 bucket"
}

output "bucket_url" {
  value = "https://${aws_s3_bucket.terraform_state.bucket}.s3.amazonaws.com"
}
