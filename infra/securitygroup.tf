
resource "aws_instance" "webserver1" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name               = "my-keypair-name"

  associate_public_ip_address = false

  monitoring                 = true
  ebs_optimized = true


   metadata_options {
    http_tokens = "required"      # Enforces IMDSv2
    http_endpoint = "enabled"
    http_put_response_hop_limit = 1
  }

  # Enable encryption for the root EBS volume
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true   # <-- Encryption enabled
  }

  tags = {
    Name = "web-EC2"
  
}
}

############################################
# 1. KMS Key for S3 Encryption
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
# 2. S3 Bucket
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
# 3. Default Encryption (aws:kms)
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
# 4. Block All Public Access
############################################
resource "aws_s3_bucket_public_access_block" "bucket1_block" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
############################################
# 1. KMS Key for S3 Encryption
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
# 2. S3 Bucket
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
# 3. Default Encryption (aws:kms)
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
# 4. Block All Public Access
############################################
resource "aws_s3_bucket_public_access_block" "bucket1_block" {
  bucket                  = aws_s3_bucket.bucket1.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "sg1" {
  name        = "web_sg1"
  description = "Allow TLS,http,ssh trafic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http"{
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow HTTP traffic from the internet"  # Added
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls"{
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description = "Allow HTTPS traffic from the internet"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description = "Allow SSH traffic from this network "
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  ip_protocol       = "-1" # semantically equivalent to all ports
  description = "Allow outbound traffic from this block"
}

