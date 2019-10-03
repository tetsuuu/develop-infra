module "sqs" {
  source = "../../modules/sqs"

  environment  = var.environment
  service_name = var.service_name
  short_env    = var.short_env
}
