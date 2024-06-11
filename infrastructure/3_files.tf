
resource "aws_s3_object" "html_files" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  content_type = "text/html"

  for_each = fileset("../dist", "**/*.html")
  key      = each.value
  source   = "../dist/${each.value}"
  etag     = filemd5("../dist/${each.value}")

  tags = local.tags
}

resource "aws_s3_object" "js_files" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  content_type = "application/javascript"

  for_each = fileset("../dist", "**/*.js")
  key      = each.value
  source   = "../dist/${each.value}"
  etag     = filemd5("../dist/${each.value}")

  tags = local.tags
}

resource "aws_s3_object" "css_files" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  content_type = "text/css"

  for_each = fileset("../dist", "**/*.css")
  key      = each.value
  source   = "../dist/${each.value}"
  etag     = filemd5("../dist/${each.value}")

  tags = local.tags
}
