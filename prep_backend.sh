#!/bin/bash -e
## ACCOUNT = service name
## BUCKET = uluru-enphoto-infra-tfstate
## STAGE = develop or staging or production ( or sandbox )
## e.g.) ../prep_backend.sh -a enphoto -b uluru-enphoto-infra-tfstate -p enphoto -s develop > terraform.tf
## S3 PATH : s3://uluru-enphoto-infra-tfstate/terraform/enphoto/develop/terraform.tfstate

init() {
  [ -z $ACCOUNT ] && ACCOUNT="$(basename `pwd`)" || ACCOUNT=$ACCOUNT

  cat << EOS
terraform {
  backend "s3" {
    bucket  = "${BUCKET}"
    key     = "terraform/${ACCOUNT}/${STAGE}/terraform.tfstate"
    region  = "ap-northeast-1"
  }
}
EOS

}

while getopts "b:s:a:" opt; do
  case "$opt" in
    a)
      ACCOUNT=$OPTARG
      ;;
    b)
      BUCKET=$OPTARG
      ;;
    s)
      STAGE=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

init
