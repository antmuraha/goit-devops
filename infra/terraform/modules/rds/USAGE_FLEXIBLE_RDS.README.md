# Usage Flexible RDS Module

Example Initialize Terraform flexible configuration for RDS module. It sets up the required variables and configurations to deploy an Aurora PostgreSQL cluster or a standard RDS PostgreSQL instance based on the provided variables file.

Initialize

```bash
cd infra/terraform
terraform init
```

Example usage:

```bash
terraform apply -var-file="modules/rds/terraform.postgres.tfvars" -target=module.rds
terraform destroy -var-file="modules/rds/terraform.postgres.tfvars" -target=module.rds
```

```bash
terraform apply -var-file="modules/rds/terraform.aurora.tfvars" -target=module.rds
terraform destroy -var-file="modules/rds/terraform.aurora.tfvars" -target=module.rds
```

After each apply, you may need to destroy the created infrastructure:
