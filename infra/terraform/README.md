# Terraform Project

## Project Structure

```text
terraform/
│
├── main.tf                  # Main file for defining resources and modules
├── backend.tf               # Configuration for backend state (S3 + DynamoDB)
├── outputs.tf               # General outputs of resources
│
├── modules/                 # Directory with all modules
│   │
│   ├── s3-backend/          # Module for S3 and DynamoDB
│   │   ├── s3.tf            # Creation of S3 bucket
│   │   ├── dynamodb.tf      # Creation of DynamoDB table
│   │   ├── variables.tf     # Variables for S3 and DynamoDB
│   │   └── outputs.tf       # Outputs for S3 bucket and DynamoDB table
│   │
│   ├── vpc/                 # Module for VPC
│   │   ├── vpc.tf           # Creation of VPC, subnets, and Internet Gateway
│   │   ├── routes.tf        # Routing configuration
│   │   ├── variables.tf     # Variables for VPC
│   │   └── outputs.tf       # Outputs for VPC resources
│   │
│   └── ecr/                 # Module for ECR
│       ├── ecr.tf           # Creation of ECR repository
│       ├── variables.tf     # Variables for ECR
│       └── outputs.tf       # Output ECR repository URL
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

- **s3-backend** - Manages S3 bucket for Terraform state and DynamoDB table for state locking.
- **vpc** - Creates VPC, public and private subnets, Internet Gateway, and route tables.
- **ecr** - Creates an ECR repository with image scanning and outputs the repository URL for use in CI/CD or ECS.
