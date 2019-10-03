terraform {
  backend "s3" {
    bucket  = "uluru-enphoto-infra-tfstate"
    key     = "infra/staging/terraform.tfstate"
    region  = "ap-northeast-1"
  }
}
