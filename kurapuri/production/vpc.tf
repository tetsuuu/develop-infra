module "service_vpc" {
  source = "../../modules/aws/vpc"

  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
}
