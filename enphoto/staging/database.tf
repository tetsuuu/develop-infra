module "aws_db_instance" {
  source = "../../modules/database"

  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  identifier              = "enphoto-stg2"
  storage                 = 45
  max_storage             = 60
  engine                  = "mysql"
  engine_version          = "5.7.17"
  instance_class          = "db.t2.large"
  name                    = "enphoto"
  user                    = "enphoto"
  password                = "" // TODO
  backup_window           = "18:00-18:30"
  maintenance_window      = "Sun:19:00-Sun:19:30"
  db_subnet_group         = "default-vpc-198d327d"
  private_sub             = module.service_vpc.private_subnets
  public_sub              = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
}
