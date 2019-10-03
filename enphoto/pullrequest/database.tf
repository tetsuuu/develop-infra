// Need to confirm
//  private_sub             = module.service_vpc.private_subnets
//  public_sub              = module.service_vpc.public_subnets
//

module "db_instance_pr01" {
  source = "../../modules/database"

  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  identifier              = "enphoto-pr-01-db"
  storage                 = 20
  max_storage             = 60
  engine                  = "mysql"
  engine_version          = "5.7.22"
  instance_class          = "db.t2.small"
  name                    = "enphoto"
  user                    = "enphoto"
  password                = "" // TODO
  backup_window           = "18:00-18:30"
  maintenance_window      = "Sun:19:00-Sun:19:30"
  db_subnet_group         = "photo-test-sub-db"
  private_sub             = module.service_vpc.private_subnets
  public_sub              = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
}

module "db_instance_pr02" {
  source = "../../modules/database"

  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  identifier              = "enphoto-pr-02-db"
  storage                 = 20
  max_storage             = 60
  engine                  = "mysql"
  engine_version          = "5.7.22"
  instance_class          = "db.t2.small"
  name                    = "enphoto"
  user                    = "enphoto"
  password                = "" // TODO
  backup_window           = "18:00-18:30"
  maintenance_window      = "Sun:19:00-Sun:19:30"
  db_subnet_group         = "photo-test-sub-db"
  private_sub             = module.service_vpc.private_subnets
  public_sub              = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
}

module "db_instance_pr03" {
  source = "../../modules/database"

  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  identifier              = "enphoto-pr-03-db"
  storage                 = 20
  max_storage             = 60
  engine                  = "mysql"
  engine_version          = "5.7.22"
  instance_class          = "db.t2.small"
  name                    = "enphoto"
  user                    = "enphoto"
  password                = "" // TODO
  backup_window           = "18:00-18:30"
  maintenance_window      = "Sun:19:00-Sun:19:30"
  db_subnet_group         = "photo-test-sub-db"
  private_sub             = module.service_vpc.private_subnets
  public_sub              = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
}
