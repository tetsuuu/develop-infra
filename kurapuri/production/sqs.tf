module "sqs" {
  source = "../../modules/aws/sqs"

  environment  = var.environment
  service_name = var.service_name
  short_env    = var.short_env
}
