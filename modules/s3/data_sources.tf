data "template_file" "bucket_policy" {
  template = file("${path.module}/resources/bucket_policy.tpl")
  vars = {
    my_domain = var.my_domain
  }
}
