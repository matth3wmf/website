resource "aws_s3_bucket_object" "style_folder" {
  bucket       = aws_s3_bucket.root_bucket.id
  acl          = "public-read"
  key          = "styles/"
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "images_folder" {
  bucket       = aws_s3_bucket.root_bucket.id
  acl          = "public-read"
  key          = "images/"
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "scripts_folder" {
  bucket       = aws_s3_bucket.root_bucket.id
  acl          = "public-read"
  key          = "scripts/"
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "site_folder" {
  bucket       = aws_s3_bucket.root_bucket.id
  acl          = "public-read"
  key          = "site/"
  content_type = "application/x-directory"
}