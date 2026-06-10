# Terraform versions
terraform {
  required_version = ">= 1.5.0"
}


# Connect S3 and DynamoDB modules
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-l5-bucket"
  table_name  = "terraform-locks"
}

# Connect VPC module
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "lesson-5-vpc"
}

# Connect ECR module
module "ecr" {
  source = "./modules/ecr"
  # ecr_name    = "lesson-5-ecr"

  repository_name      = "lesson-5-ecr"
  image_tag_mutability = "IMMUTABLE"

  # scan_on_push = true
}

