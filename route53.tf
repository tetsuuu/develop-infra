/*
resource "aws_ses_domain_dkim" "enphoto" {}

data "aws_ses_domain_identity" "enphoto" {
  domain = "en-photo.net"
}

data "aws_ses_domain_identity" "kurapuri" {
  domain = "kurapuri.com"
}
*/

// enphoto records
data "aws_route53_zone" "enphoto_root_zone" {
  name = "en-photo.net."
}

// common records
resource "aws_route53_record" "enphoto-acm-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "_b3efec7472fbdb5aa2170698fadc6195"
  type    = "CNAME"
  ttl     = "300"
  records = ["_2ef9efb5d62355a9bf4e8ef137a98022.acm-validations.aws."] //${aws_acm_certificate.domain_validation_options.value}  ??
}

resource "aws_route53_record" "enphoto-ses-txt" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "_amazonses"
  type    = "TXT"
  ttl     = "1800"
  records = ["RKFyZ6dtlJpcSEnI9T0xncPJ/nlh10XHNbcWLK8pfMM="] //${aws_ses_domain.*.*} ??
}

resource "aws_route53_record" "enphoto-email-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "email"
  type    = "CNAME"
  ttl     = "300"
  records = ["mailgun.org"]
}

resource "aws_route53_record" "enphoto-dkim-txt" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "k1._domainkey"
  type    = "TXT"
  ttl     = "300"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvD59GG4fz4uZxl67TP7gl3a98yJy1uQ6d0YLNUhSsPkTbIeeRplHD2IoX+j699vsZjduZvQ9NF+EnHIwUmgq0PbPRIDgZkYlUM21uSyCtRyf1mGPNSsudwjUjaZs8CBJiucZrVvw/ygY4gkDa0cVtQGZuZmNQJTRW0FGmxZxv4wIDAQAB"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "enphoto-dkim-1-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "mjreuq4qrikpwrih7bq2pm3fwrhvnzps._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["mjreuq4qrikpwrih7bq2pm3fwrhvnzps.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "enphoto-dkim-2-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "moeky6xh4umtcgyhlqegpgohk5v2lfez._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["moeky6xh4umtcgyhlqegpgohk5v2lfez.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "enphoto-dkim-3-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "wd34rk3tc6yeybr4cmynb2ehafqczdqh._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["wd34rk3tc6yeybr4cmynb2ehafqczdqh.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "enphoto-recognition-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "face-recognition"
  type    = "CNAME"
  ttl     = "300"
  records = ["face-recognition.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

// production records
resource "aws_route53_record" "enphoto-prod-web-a" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "${data.aws_route53_zone.enphoto_root_zone.name}"
  type    = "A"

  alias {
    name                   = "enphoto-prod-web.ap-northeast-1.elasticbeanstalk.com" // from EB
    zone_id                = "Z1R25G3KIG2GBW"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "enphoto-prod-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "prod"
  type    = "CNAME"
  ttl     = "300"
  records = ["enphoto-prod-web.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

resource "aws_route53_record" "enphoto-prod-web-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["enphoto-prod-web.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

resource "aws_route53_record" "enphoto-prod-image-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "image"
  type    = "CNAME"
  ttl     = "300"
  records = ["dfufds5itwjrt.cloudfront.net"] //${aws_cloudfront_distribution.pr02_image.domain_name}
}

resource "aws_route53_record" "enphoto-prod-lp-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "lp"
  type    = "CNAME"
  ttl     = "300"
  records = ["en-kurapuri.netlify.com"]
}

// staging records
resource "aws_route53_record" "enphoto-pr01-image-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr01-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d1p1fxpt9tns1w.cloudfront.net"] //${aws_cloudfront_distribution.pr01_image.domain_name}
}

resource "aws_route53_record" "enphoto-pr01-pdf-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr01-pdf"
  type    = "CNAME"
  ttl     = "60"
  records = ["d3puo3gmj5d1dd.cloudfront.net"] //${aws_cloudfront_distribution.pr01_pdf.domain_name}
}

resource "aws_route53_record" "enphoto-pr01-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr01"
  type    = "CNAME"
  ttl     = "300"
  records = ["enphoto-dev-pr-01.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

resource "aws_route53_record" "enphoto-pr02-image-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr02-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d11kzrzbnvyct9.cloudfront.net"] //${aws_cloudfront_distribution.pr02_image.domain_name}
}

resource "aws_route53_record" "enphoto-pr02-pdf-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr02-pdf"
  type    = "CNAME"
  ttl     = "60"
  records = ["d3hdk3ynuabbj3.cloudfront.net"] //${aws_cloudfront_distribution.pr02_pdf.domain_name}
}

resource "aws_route53_record" "enphoto-pr02-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "pr02"
  type    = "CNAME"
  ttl     = "300"
  records = ["enphoto-dev-pr-02.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

resource "aws_route53_record" "enphoto-staging-ftp-a" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "staging-ftp"
  type    = "A"
  ttl     = "300"
  records = ["13.112.220.87"] //fixed
}

resource "aws_route53_record" "enphoto-staging-image-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "staging-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2d21yes80pug9.cloudfront.net"] //${aws_cloudfront_distribution.enphoto_staging_image.domain_name}
}

resource "aws_route53_record" "enphoto-staging-pdf-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "staging-pdf"
  type    = "CNAME"
  ttl     = "60"
  records = ["d317sbv4l3ye6n.cloudfront.net"] //${aws_cloudfront_distribution.enphoto_staging_pdf.domain_name}
}

resource "aws_route53_record" "enphoto-staging2-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "staging2"
  type    = "CNAME"
  ttl     = "300"
  records = ["enphoto-stg2.ap-northeast-1.elasticbeanstalk.com"] //from EB
}

// develop records
resource "aws_route53_record" "enphoto-dev-image-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "dev-image"
  type    = "CNAME"
  ttl     = "60"
  records = ["d1pox1mgjt79yu.cloudfront.net"] //${aws_cloudfront_distribution.s3_distribution_image.domain_name}
}

resource "aws_route53_record" "enphoto-dev-pdf-cname" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "dev-pdf"
  type    = "CNAME"
  ttl     = "60"
  records = ["d3v53ucgks1cnb.cloudfront.net"] //${aws_cloudfront_distribution.s3_distribution_pdf.domain_name}
}

// TODO change resourcename to service by
resource "aws_route53_record" "cloudfront_thumbnail" {
  zone_id = "${data.aws_route53_zone.enphoto_root_zone.zone_id}"
  name    = "dev-spica-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d10ukgde0n7dvd.cloudfront.net"] //${aws_cloudfront_distribution.s3_distribution_thumbnail.domain_name}
}

// kurapuri records
data "aws_route53_zone" "kurapuri_root_zone" {
  name = "kurapuri.com."
}

// common records
resource "aws_route53_record" "kurapuri-acm-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "_541244b9eba1f84b647870e9fd2f85af"
  type    = "CNAME"
  ttl     = "300"
  records = ["_8870486b2d5575976dd2065a8a105d83.acm-validations.aws."] //${aws_acm_certificate.*.*}
}

resource "aws_route53_record" "kurapuri-ses-txt" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "_amazonses"
  type    = "TXT"
  ttl     = "1800"
  records = ["+W/whq7Gj5INQAyyYI+PC4g+ywQpKcKzZpsM38pz+ds="] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "kurapuri-dkim-txt" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "mailo._domainkey"
  type    = "TXT"
  ttl     = "300"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCfolVsRub6o+aswMq4thsd+2tgePLbxeOLYW+xssP8mHzWoeX+2FR/PDd0X+T5g6KC4Eul6PI3ZPr3smKpolB1o3/15bO3zKquuf39PuYa1ha2mGfZUcRubrpbw/S2kDJT5r/Icr9y9s5/CCHXM5tiDDBWsahvGU3p8IxZoDphdwIDAQAB"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "kurapuri-dkim-1-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "7fgyl5waoyqjfcpkosobe56aityvi3cj._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["7fgyl5waoyqjfcpkosobe56aityvi3cj.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "kurapuri-dkim-2-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "mvvepltwazbahjuqa5vcifh3gf4ejhhw._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["mvvepltwazbahjuqa5vcifh3gf4ejhhw.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "kurapuri-dkim-3-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "nbagavqxlv5fcav7gybjhdlmvn53yndw._domainkey"
  type    = "CNAME"
  ttl     = "1800"
  records = ["nbagavqxlv5fcav7gybjhdlmvn53yndw.dkim.amazonses.com"] //${aws_ses_domain_dkim.*.*} ??
}

resource "aws_route53_record" "kurapuri-email-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "email"
  type    = "CNAME"
  ttl     = "300"
  records = ["mailgun.org"] //fixed
}

// production records
resource "aws_route53_record" "kurapuri-prod-web-a" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "${data.aws_route53_zone.kurapuri_root_zone.name}"
  type    = "A"

  alias {
    name                   = "kurapuri-prod-web.ap-northeast-1.elasticbeanstalk.com" // from EB
    zone_id                = "Z1R25G3KIG2GBW"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "kurapuri-prod-app-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "app2"
  type    = "CNAME"
  ttl     = "300"
  records = ["kurapuri-prod-web.ap-northeast-1.elasticbeanstalk.com"] // from EB
}

resource "aws_route53_record" "kurapuri-prod-web-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2q809dgq4mnsj.cloudfront.net"] //${aws_cloudfront_distribution.kurapuri_prod_web.domain_name}
}

resource "aws_route53_record" "kurapuri-prod-image-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2q809dgq4mnsj.cloudfront.net"] //${aws_cloudfront_distribution.kurapuri_prod_web.domain_name}
}

resource "aws_route53_record" "kurapuri-prod-lp-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "lp"
  type    = "CNAME"
  ttl     = "300"
  records = ["kurapuri-prod-web.ap-northeast-1.elasticbeanstalk.com"] //${aws_cloudfront_distribution.kurapuri_prod_lp.domain_name}
}

resource "aws_route53_record" "kurapuri-prod-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "prod"
  type    = "CNAME"
  ttl     = "300"
  records = ["kurapuri-prod-web.ap-northeast-1.elasticbeanstalk.com"] // from EB
}

// staging records
resource "aws_route53_record" "kurapuri-staging-image-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "staging-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d3vmy2f0qltvn2.cloudfront.net"] //${aws_cloudfront_distribution.kurapuri_staging_image.domain_name}
}

resource "aws_route53_record" "kurapuri-staging-pdf-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "staging-pdf"
  type    = "CNAME"
  ttl     = "60"
  records = ["d1dgok1mobkhwc.cloudfront.net"] //${aws_cloudfront_distribution.kurapuri_staging_image.domain_name}
}

resource "aws_route53_record" "kurapuri-staging2-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "staging2"
  type    = "CNAME"
  ttl     = "300"
  records = ["kurapuri-stg2.ap-northeast-1.elasticbeanstalk.com"] // from EB
}

// develop records
resource "aws_route53_record" "kurapuri-dev-image-cname" {
  zone_id = "${data.aws_route53_zone.kurapuri_root_zone.zone_id}"
  name    = "dev-image"
  type    = "CNAME"
  ttl     = "300"
  records = ["d3u5onlu4ffx02.cloudfront.net"] //${aws_cloudfront_distribution.s3_distribution_thumbnail.domain_name}
}
