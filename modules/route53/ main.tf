# Adds records to existing hosted zone
resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = var.my_domain
  ttl             = 30
  type            = "NS"
  zone_id         = data.aws_route53_zone.website_zone.zone_id

  # Use hosted zones NS records
  records = data.aws_route53_zone.website_zone.name_servers
}

resource "aws_route53_record" "root_domain" {
  zone_id = data.aws_route53_zone.website_zone.zone_id
  name    = var.my_domain
  type    = "A"

  alias {
    name                   = "s3-website.eu-west-2.amazonaws.com."
    zone_id                = var.root_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_domain" {
  zone_id = data.aws_route53_zone.website_zone.zone_id
  name    = "www.${var.my_domain}"
  type    = "A"

  alias {
    name                   = "s3-website.eu-west-2.amazonaws.com."
    zone_id                = var.subdomain_hosted_zone_id
    evaluate_target_health = false
  }
}