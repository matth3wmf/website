# Assumes pre-existing hosted zone as registered Route53 Domains are not supported as a resource or data source
# and therefore cannot be updated/created with the automatically generated name servers made by aws_route53_zone :(

data "aws_route53_zone" "website_zone" {
  name         = var.my_domain
}