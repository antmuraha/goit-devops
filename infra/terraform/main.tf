# Terraform versions
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
  }
}


# Connect S3 backend module
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-terraform-state-bucket"
}

# Connect VPC module
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_name           = "lesson-8-9-vpc"
}

# Connect ECR module
module "ecr" {
  source = "./modules/ecr"
  # ecr_name    = "lesson-8-9-ecr"

  repository_name      = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  # scan_on_push = true
}

# Connect EKS module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = "lesson-8-9-eks"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  node_group_name    = "lesson-8-9-nodes"
  node_count         = 2
  node_instance_type = "t3.small"
}


module "rds" {
  source = "./modules/rds"

  name           = var.rds_name
  use_aurora     = var.rds_use_aurora
  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  # --- Aurora-only ---
  aurora_instance_count         = var.rds_aurora_instance_count
  parameter_group_family_aurora = "aurora-postgresql18"


  # --- RDS-only ---
  parameter_group_family_rds = "postgres18"

  # Common
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  db_name                 = var.rds_db_name
  username                = "postgres"
  password                = "admin123AWS23"
  subnet_ids              = module.vpc.private_subnet_ids
  publicly_accessible     = false
  vpc_id                  = module.vpc.vpc_id
  multi_az                = var.rds_multi_az
  backup_retention_period = 1
  parameters = {
    max_connections            = "20"
    log_min_duration_statement = "500"
    log_statement              = "all"
    work_mem                   = "8192"
  }

  ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}



# Connect Jenkins module
module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  kubeconfig   = "./kubeconfig"

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  jenkins_admin_username = var.jenkins_admin_username
  jenkins_admin_password = var.jenkins_admin_password

  ecr_registry = module.ecr.repository_url

  depends_on = [
    module.eks
  ]
}

provider "aws" {
  region = "us-east-1"
}

# START KUBERNETES_AND_HELM_PROVIDERS
# The Kubernetes and Helm providers are configured in the Jenkins module to avoid circular dependencies during the initial apply.
# After the first apply, you can uncomment these blocks to allow Terraform to manage Jenkins resources directly.
data "aws_eks_cluster" "this" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
# END KUBERNETES_AND_HELM_PROVIDERS

module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"
  depends_on = [
    module.eks
  ]
}

