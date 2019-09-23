{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3OIC1NJRUT25W"
      },
      "Action": "s3:GetObject",
      "Resource": "${resource_bucket}/*"
    }
  ]
}

