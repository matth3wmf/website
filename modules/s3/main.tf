resource "aws_s3_bucket" "root_bucket" {
  bucket = var.my_domain
  policy = data.template_file.bucket_policy.rendered

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "subdomain_bucket" {
  bucket = "www.${var.my_domain}"
  website {
    redirect_all_requests_to = "http://${aws_s3_bucket.root_bucket.id}"
  }
}

resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.root_bucket.id
  key          = "index.html"
  source       = "${path.module}/resources/website-content/index.html"
  content_type = "text/html"

  etag = filemd5("${path.module}/resources/website-content/index.html")
}

resource "aws_s3_bucket_object" "style_folder" {
  bucket       = aws_s3_bucket.root_bucket.id
  acl          = "public-read"
  key          = "styles/"
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "style_file" {
  bucket       = aws_s3_bucket.root_bucket.id
  key          = "${aws_s3_bucket_object.style_folder.key}site.css"
  source       = "${path.module}/resources/website-content/styles/site.css"
  content_type = "text/css"

  etag = filemd5("${path.module}/resources/website-content/styles/site.css")
}

