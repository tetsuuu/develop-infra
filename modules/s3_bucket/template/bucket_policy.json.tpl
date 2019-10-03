{
  "Id": "PolicyForCloudFrontPrivateContent",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${resource_bucket}/*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${cdn_identity}"
        ]
      }
    }
  ]
}
