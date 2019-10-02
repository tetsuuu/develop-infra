module "log_aggregator" {
  source = "../../modules/aws/elasticsearch"

  elasticsearch_version   = "7.1"
  instance_type           = "t2.small.elasticsearch"
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  private_subnets         = module.service_vpc.private_subnets
  public_subnets          = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
}
