# Creates TLS cert for domain and sub-domain
resource "aws_acm_certificate" "my_domain_cert" {
  domain_name       = var.my_root_domain
  subject_alternative_names = var.my_subdomains
  validation_method = "DNS"
}

# Creates root CNAME record for proof of ownership of the domain to the CA
resource "aws_route53_record" "root_cert_validation" {
  name    = aws_acm_certificate.my_domain_cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.my_domain_cert.domain_validation_options.0.resource_record_type
  zone_id = var.website_zone_id
  records = [aws_acm_certificate.my_domain_cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

# Creates subdomain CNAME records for proof of ownership of the domain to the CA
resource "aws_route53_record" "subdomain_cert_validation" {
  count   = length(var.my_subdomains)
  name    = aws_acm_certificate.my_domain_cert.domain_validation_options[count.index+1].resource_record_name
  type    = aws_acm_certificate.my_domain_cert.domain_validation_options[count.index+1].resource_record_type
  zone_id = var.website_zone_id
  records = [aws_acm_certificate.my_domain_cert.domain_validation_options[count.index+1].resource_record_value]
  ttl     = 60
}

# Validates that we have proved ownership of the domains...then our cert will be signed by the CA
# ...this can take a while
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.my_domain_cert.arn
  validation_record_fqdns = concat([aws_route53_record.root_cert_validation.fqdn], tolist(aws_route53_record.subdomain_cert_validation[*].fqdn))
}

# Create CDN for distributing content over TLS from S3 Bucket
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.root_bucket_regional_domain_name
    origin_id   = "S3-${var.my_root_domain}"

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.my_root_domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  aliases = concat([var.my_root_domain], var.my_subdomains)

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    bucket = aws_s3_bucket.log_bucket.bucket_domain_name
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method = "sni-only"
  }
}

# Make root domain point to CDN
resource "aws_route53_record" "ssl_root_domain" {
  zone_id = var.website_zone_id
  name    = var.my_root_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Make all subdomains point to CDN
resource "aws_route53_record" "ssl_subdomains" {
  count    = length(var.my_subdomains)
  zone_id  = var.website_zone_id
  name     = var.my_subdomains[count.index]
  type     = "CNAME"
  records  = [aws_cloudfront_distribution.s3_distribution.domain_name]
  ttl      = 60
}