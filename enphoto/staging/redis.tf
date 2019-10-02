module "elasticache_redis" {
  source = "../../modules/aws/redis"

  engine_version = "3.2.4"
  environment    = var.environment
  service_name   = var.service_name
  short_env      = var.short_env
  cluster_name   = "enphoto-stg-cache"
  private_subnets = module.service_vpc.private_subnets
  target_vpc      = module.service_vpc.vpc_id
}