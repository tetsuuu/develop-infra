variable "service_name" {}
variable "environment" {}
variable "short_env" {}
variable "elasticsearch_version" {}
variable "instance_type" {}
variable "maintenance_cidr_blocks" {}
variable "target_vpc" {}
variable "private_subnets" {}
variable "public_subnets" {}

variable "default_sg" {
  default = "sg-47a0de20"
}
