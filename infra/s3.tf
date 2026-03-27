############################################
# KMS KEY FOR S3 ENCRYPTION
############################################
resource "aws_kms_key" "s3_kms_key" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "s3_kms_key_alias" {
  name          = "alias/s3-bucket-key"
  target_key_id = aws_kms_key.s3_kms_key.key_id
}

############################################
# S3 BUCKET
############################################
resource "aws_s3_bucket" "bucket1" {
  bucket = "test-bucket-1-qzee-project"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

############################################
# DEFAULT ENCRYPTION (aws:kms)
############################################
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket1_encryption" {
  bucket = aws_s3_bucket.bucket1.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

############################################
# BLOCK PUBLIC ACCESS
############################################
resource "aws_s3_bucket_public_access_block" "bucket1_block" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
