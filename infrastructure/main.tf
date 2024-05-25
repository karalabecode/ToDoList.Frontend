terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "terraform-state-oafi"
    key                  = "ToDoList.Frontend/terraform.tfstate"
    workspace_key_prefix = "ToDoList"
    region               = "eu-central-1"
  }
}

locals {
  tags = {
    "App" = "ToDoList"
  }
}

module "validator" {
  source             = "./validator"
  allowed_workspaces = ["dev"]
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "todolist-dev-web"

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket.json
}

data "aws_iam_policy_document" "website_bucket" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::todolist-dev-web/*"]
  }
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

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
