# Terraform Project

## Project Structure

```text
terraform/
│
├── main.tf                  # Main file for defining resources and modules
├── backend.tf               # Configuration for backend state (S3)
├── outputs.tf               # General outputs of resources
│
├── modules/                 # Directory with all modules
│   │
│   ├── s3-backend/          # Module for S3 backend
│   │   ├── s3.tf            # Creation of S3 bucket
│   │   ├── variables.tf     # Variables for S3
│   │   └── outputs.tf       # Outputs for S3 bucket
│   │
│   ├── vpc/                 # Module for VPC
│   │   ├── vpc.tf           # Creation of VPC, subnets, and Internet Gateway
│   │   ├── nat.tf           # Creation of NAT Gateway
│   │   ├── routes.tf        # Routing configuration
│   │   ├── variables.tf     # Variables for VPC
│   │   └── outputs.tf       # Outputs for VPC resources
│   │
│   ├── ecr/                 # Module for ECR
│   │   ├── ecr.tf           # Creation of ECR repository
│   │   ├── variables.tf     # Variables for ECR
│   │   └── outputs.tf       # Output ECR repository URL
│   │
│   └── eks/                 # Module for Kubernetes cluster
│       ├── eks.tf           # Creation of the cluster
│       ├── variables.tf     # Variables for EKS
│       └── outputs.tf       # Outputs for EKS cluster
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища
│
└── README.md                # Project documentation

```

## Commands for initialization, validation, formatting, and deployment

- `terraform init` - Initialize Terraform and download required providers.
- `terraform validate` - Validate configuration files for syntax and internal consistency.
- `tflint` - Run static analysis on Terraform code to detect issues, enforce best practices, and improve code quality.
- `terraform fmt` - Format Terraform code according to standard style conventions.
- `terraform plan` - Show execution plan.
- `terraform apply` - Apply changes to create resources.
- `terraform destroy` - Destroy all created resources.

## Modules

- **s3-backend** - Manages S3 bucket for Terraform state.
- **vpc** - Creates VPC, public and private subnets, Internet Gateway, and route tables.
- **ecr** - Creates an ECR repository with image scanning and outputs the repository URL for use in CI/CD or ECS.
