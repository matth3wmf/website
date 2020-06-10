resource "aws_s3_bucket_object" "index_file" {
  bucket       = aws_s3_bucket.root_bucket.id
  key          = "index.html"
  source       = "${path.module}/resources/website-content/index.html"
  content_type = "text/html"

  etag = filemd5("${path.module}/resources/website-content/index.html")
}

resource "aws_s3_bucket_object" "site_files" {
  for_each = fileset("${path.module}/resources/website-content/site/", "*")

  bucket = aws_s3_bucket.root_bucket.id
  key    = "${aws_s3_bucket_object.site_folder.key}${each.value}"
  source = "${path.module}/resources/website-content/site/${each.value}"
  content_type = "text/html"

  etag   = filemd5("${path.module}/resources/website-content/site/${each.value}")
}

resource "aws_s3_bucket_object" "style_files" {
  for_each = fileset("${path.module}/resources/website-content/styles/", "*")

  bucket = aws_s3_bucket.root_bucket.id
  key    = "${aws_s3_bucket_object.style_folder.key}${each.value}"
  source = "${path.module}/resources/website-content/styles/${each.value}"
  content_type = "text/css"

  etag   = filemd5("${path.module}/resources/website-content/styles/${each.value}")
}

resource "aws_s3_bucket_object" "script_files" {
  for_each = fileset("${path.module}/resources/website-content/scripts/", "*")

  bucket = aws_s3_bucket.root_bucket.id
  key    = "${aws_s3_bucket_object.scripts_folder.key}${each.value}"
  source = "${path.module}/resources/website-content/scripts/${each.value}"
  content_type = "text/javascript"

  etag   = filemd5("${path.module}/resources/website-content/scripts/${each.value}")
}

resource "aws_s3_bucket_object" "image_files" {
  for_each = fileset("${path.module}/resources/website-content/images/", "*")

  bucket = aws_s3_bucket.root_bucket.id
  key    = "${aws_s3_bucket_object.images_folder.key}${each.value}"
  source = "${path.module}/resources/website-content/images/${each.value}"
  content_type = "image/png"

  etag   = filemd5("${path.module}/resources/website-content/images/${each.value}")
}