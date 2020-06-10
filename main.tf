module "websites_dns" {
  source                   = "./modules/route53"
  my_domain                = var.my_domain
  root_hosted_zone_id      = module.website_content.root_bucket_hosted_zone_id
  subdomain_hosted_zone_id = module.website_content.subdomain_bucket_hosted_zone_id
}

module "website_content" {
  source    = "./modules/s3"
  my_domain = var.my_domain
}