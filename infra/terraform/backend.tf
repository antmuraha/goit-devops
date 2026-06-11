terraform {
  backend "s3" {
    bucket       = "goit-terraform-state-bucket"
    key          = "terraform/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

