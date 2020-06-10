output "root_bucket_hosted_zone_id" {
  value = aws_s3_bucket.root_bucket.hosted_zone_id
}

output "subdomain_bucket_hosted_zone_id" {
  value = aws_s3_bucket.subdomain_bucket.hosted_zone_id
}