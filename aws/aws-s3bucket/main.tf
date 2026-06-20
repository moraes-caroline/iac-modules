resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = merge(var.tags, { Environment = var.environment })
}
 
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
 
  versioning_configuration {
    status     = var.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = var.mfa_delete_enabled ? "Enabled" : "Disabled"
  }
}
 
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.encryption_type == null ? 0 : 1
  bucket = aws_s3_bucket.this.id
 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_type
      kms_master_key_id = var.encryption_type == "aws:kms" ? var.kms_key_id : null
    }
  }
}
 
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
 
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
 
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
 
  rule {
    id     = "transition-rule"
    status = "Enabled"
 
    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }
 
    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }
 
    expiration {
      days = var.expiration_days
    }
  }
}
 
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.s3_bucket_website_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
 
  index_document {
    suffix = var.s3_bucket_website_index_document
  }
 
  error_document {
    key = var.s3_bucket_website_error_document
  }
}
 
resource "aws_s3_bucket_logging" "this" {
  count         = var.logging_enabled ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.log_bucket
  target_prefix = var.log_prefix
}
 
#--------------------- VPC Endpoint ---------------------#
 
resource "aws_vpc_endpoint" "this" {
  count             = var.enable_vpc_endpoint ? 1 : 0
  vpc_id            = var.vpc_endpoint_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = var.vpc_endpoint_type
 
  route_table_ids = var.vpc_endpoint_route_table_ids
  tags = merge(
    var.tags,
    {
      Name = "s3-endpoint-${var.environment}"
    }
  )
}