module "website_dns" {
  source    = "./modules/route53"
  my_domain = var.my_root_domain
}

module "website_content" {
  source         = "./modules/s3"
  my_root_domain = var.my_root_domain
}

module "website_tls" {
  source                           = "./modules/cloudfront"
  my_root_domain                   = var.my_root_domain
  my_subdomains                    = var.my_subdomains
  root_bucket_regional_domain_name = module.website_content.root_bucket_regional_domain_name
  cloudfront_access_identity_path  = module.website_content.cloudfront_access_identity_path
  website_zone_id                  = module.website_dns.website_zone_id
}