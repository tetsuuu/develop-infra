module "service_vpc" {
  source = "../../modules/aws/vpc"

  environment             = "staging"
  service_name            = var.service_name
  short_env               = "stg"
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
}
