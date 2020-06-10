# Makes the NS record the same as the hosted zones nameservers
resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = var.my_domain
  ttl             = 30
  type            = "NS"
  zone_id         = data.aws_route53_zone.website_zone.zone_id

  # Use hosted zones registered nameservers
  records = data.aws_route53_zone.website_zone.name_servers
}

# You need to:
# - Ensure you have an existing hosted zone for your domain
# - Ensure your name servers are the same for:
#       - Registered Domain
#       - Hosted Zone
#       - NS Record in Hosted Zone (Done by Terraform)