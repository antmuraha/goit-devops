# Usage Flexible RDS Module

This module provides a **flexible RDS solution** that supports both:

- Standard PostgreSQL RDS instance
- Aurora PostgreSQL cluster

Selection is controlled via the `use_aurora` variable.

---

## Initialize

```bash
cd infra/terraform
terraform init
```

---

## Example usage

### Standard RDS (PostgreSQL)

```bash
terraform apply -var-file="modules/rds/terraform.postgres.tfvars" -target=module.rds
terraform destroy -var-file="modules/rds/terraform.postgres.tfvars" -target=module.rds
```

### Aurora PostgreSQL Cluster

```bash
terraform apply -var-file="modules/rds/terraform.aurora.tfvars" -target=module.rds
terraform destroy -var-file="modules/rds/terraform.aurora.tfvars" -target=module.rds
```

---

## Module usage example

```hcl
module "rds" {
  source = "./modules/rds"

  name           = var.rds_name
  use_aurora     = var.rds_use_aurora
  engine         = var.rds_engine
  engine_version = var.rds_engine_version

  # Aurora settings
  aurora_instance_count         = var.rds_aurora_instance_count
  parameter_group_family_aurora = "aurora-postgresql18"

  # Standard RDS settings
  parameter_group_family_rds = "postgres18"
  allocated_storage          = var.rds_allocated_storage

  # Common settings
  instance_class          = var.rds_instance_class
  db_name                 = var.rds_db_name
  username                = "postgres"
  password                = "your-secure-password"
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  publicly_accessible     = false
  multi_az               = var.rds_multi_az

  ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  parameters = {
    max_connections = "20"
  }

  tags = {
    Environment = "dev"
    Project     = "lesson-fp"
  }
}
```

---

## Variables

### Core configuration

- `name` - Name of RDS instance or Aurora cluster
- `db_name` - Initial database name
- `engine` - Database engine (e.g. `postgres`)
- `engine_version` - Engine version

---

### Deployment type

- `use_aurora` - Switch between:
    - `false` → standard RDS instance
    - `true` → Aurora cluster

---

### Instance configuration

- `instance_class` - DB instance type (e.g. `db.t3.micro`)
- `allocated_storage` - Storage size (RDS only)
- `aurora_instance_count` - Number of Aurora instances (writer + readers)

---

### Network configuration

- `vpc_id` - VPC ID
- `subnet_ids` - Subnets for DB placement
- `publicly_accessible` - Public access toggle
- `ingress_rules` - Security group rules

---

### Authentication

- `username` - Master username
- `password` - Master password (sensitive)

---

### Parameters

- `parameters` - DB engine parameters (map)
- `parameter_group_family_rds` - Parameter group family for RDS
- `parameter_group_family_aurora` - Parameter group family for Aurora

---

### Availability & backups

- `multi_az` - Enable Multi-AZ deployment (RDS)
- `backup_retention_period` - Backup retention in days

---

### Tags

- `tags` - Resource tagging map

---

## How to switch database type

### Standard RDS

```hcl
use_aurora = false
```

### Aurora Cluster

```hcl
use_aurora = true
```

---

## How to change engine or version

Modify:

```hcl
engine         = "postgres"
engine_version = "18.3"
```

Examples:

- PostgreSQL: `postgres`
- Aurora PostgreSQL: `aurora-postgresql`

---

## How to change instance size

```hcl
instance_class = "db.t3.micro"
```

Examples:

- Small: `db.t3.micro`
- Medium: `db.t3.small`
- Production: `db.t3.medium+`

---

## Notes

- Aurora mode automatically ignores `allocated_storage`
- Standard RDS uses single instance model
- Security group allows access only via defined `ingress_rules`
