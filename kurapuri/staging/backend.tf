terraform {
  backend "s3" {
    bucket  = var.state_bucket
    key     = "infra/${var.environment}/terraform.tfstate"
    region  = var.region
  }
}
