#!/bin/bash -e
## ACCOUNT = service name
## BUCKET = uluru-enphoto-infra-tfstate
## STAGE = develop or staging or production ( or sandbox )
## e.g.) ../../prep_backend.sh -a enphoto -s develop > terraform.tf
## S3 PATH : s3://uluru-enphoto-infra-tfstate/infra/develop/terraform.tfstate

init() {
  [ -z $ACCOUNT ] && ACCOUNT="$(basename `pwd`)" || ACCOUNT=$ACCOUNT

  cat << EOS
terraform {
  backend "s3" {
    bucket  = "uluru-${ACCOUNT}-infra-tfstate"
    key     = "infra/${STAGE}/terraform.tfstate"
    region  = "ap-northeast-1"
  }
}
EOS

}

while getopts "s:a:" opt; do
  case "$opt" in
    a)
      ACCOUNT=$OPTARG
      ;;
    s)
      STAGE=$OPTARG
      ;;
  esac
done

shift $((OPTIND-1))

init
