resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${var.environment}-${var.bucket_suffix}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
  }
}

# Enable versioning — keeps history of all file changes
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt everything at rest with AES-256
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block ALL public access — nothing leaks accidentally
resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
