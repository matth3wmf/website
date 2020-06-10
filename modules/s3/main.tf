resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Personal websites origin access identity"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.root_bucket.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.root_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "root_bucket" {
  bucket = var.my_root_domain

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}