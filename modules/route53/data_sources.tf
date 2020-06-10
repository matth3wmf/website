# We have to use an existing hosted zone as the nameservers cannot be set and there is no way of updating the domains
# registered name servers without using local-exec and the aws cli
data "aws_route53_zone" "website_zone" {
  name = var.my_domain
}