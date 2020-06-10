variable "root_bucket_regional_domain_name" {
  type = string
}

variable "my_root_domain" {
  type = string
}

variable "my_subdomains" {
  type = list(string)
}

variable "cloudfront_access_identity_path" {
  type = string
}

variable "website_zone_id" {
  type = string
}