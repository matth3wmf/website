output "root_bucket_regional_domain_name" {
  value = aws_s3_bucket.root_bucket.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}