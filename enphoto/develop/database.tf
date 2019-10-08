module "aws_db_instance" {
  source = "../../modules/database"

  db_identifier           = "enphoto-dev-mysql57"
  environment             = var.environment
  service_name            = var.service_name
  short_env               = var.short_env
  maintenance_cidr_blocks = var.maintenance_cidr_blocks
  identifier              = "enphoto-dev-mysql57"
  storage                 = 20
  max_storage             = 60
  engine                  = "mysql"
  engine_version          = "5.7.22"
  instance_class          = "db.t2.micro"
  name                    = "enphoto"
  user                    = "enphoto"
  password                = "" // TODO
  backup_window           = "13:47-14:17"
  maintenance_window      = "Mon:19:21-Mon:19:51"
  db_subnet_group         = "photo-dev-sub-db"
  private_sub             = module.service_vpc.private_subnets
  public_sub              = module.service_vpc.public_subnets
  target_vpc              = module.service_vpc.vpc_id
  vpc_cidr_block          = module.service_vpc.cidr_block
  sg_description          = "enphoto-dev-rds"
}
