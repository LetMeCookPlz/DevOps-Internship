resource "aws_s3_bucket" "static_website" {
  bucket = "tymur-s3-static-website"
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_website" {
  depends_on = [
    aws_s3_bucket_public_access_block.static_website,
    aws_s3_bucket_ownership_controls.static_website,
  ]

  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.static_website.json

  depends_on = [aws_s3_bucket_public_access_block.static_website]
}

data "aws_iam_policy_document" "static_website" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.static_website.arn}/*",
    ]
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  content      = file("${path.module}/index.html")
  content_type = "text/html"
  acl          = "public-read"

  depends_on = [aws_s3_bucket_public_access_block.static_website]
}