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

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
  depends_on = [
    module.eks
  ]
}
