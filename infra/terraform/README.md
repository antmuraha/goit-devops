Description of the project structure.
Commands for initialization and launch:
terraform init
terraform plan
terraform apply
terraform destroy

Explanation of each module: s3-backend, vpc, ecr.

terraform/
│
├── main.tf                  # Main file for defining resources and modules
├── backend.tf               # Configuration for backend state (S3 + DynamoDB)
├── outputs.tf               # General output of resources
│
├── modules/                 # Directory with all modules
│   │
│   ├── s3-backend/          # Module for S3 and DynamoDB
│   │   ├── s3.tf            # Creation of S3 bucket
│   │   ├── dynamodb.tf      # Creation of DynamoDB
│   │   ├── variables.tf     # Variables for S3
│   │   └── outputs.tf       # Output information about S3 and DynamoDB
│   │
│   ├── vpc/                 # Module for VPC
│   │   ├── vpc.tf           # Creation of VPC, subnets, Internet Gateway
│   │   ├── routes.tf        # Routing configuration
│   │   ├── variables.tf     # Variables for VPC
│   │   └── outputs.tf       # Output information about VPC
│   │
│   └── ecr/                 # Module for ECR
│       ├── ecr.tf           # Creation of ECR repository
│       ├── variables.tf     # Variables for ECR
│       └── outputs.tf       # Output ECR repository URL
│
└── README.md                # Project documentation

