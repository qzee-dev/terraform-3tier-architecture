############################################
# EC2 LAUNCH TEMPLATE WITH SECRETS ACCESS
############################################

# ============================================
# IAM ROLE FOR EC2 (Secrets Manager Access)
# ============================================
resource "aws_iam_role" "ec2_rds_secrets_role" {
  name = "${var.project_name}-${var.environment}-ec2-rds-secrets-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-rds-secrets-role"
  }
}

# ============================================
# IAM POLICY FOR SECRETS MANAGER ACCESS
# ============================================
resource "aws_iam_policy" "ec2_rds_secrets_policy" {
  name        = "${var.project_name}-${var.environment}-ec2-rds-secrets-policy"
  description = "Policy for EC2 to read RDS credentials from Secrets Manager"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadRDSSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.rds_credentials.arn
      },
      {
        Sid    = "DecryptWithKMS"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.rds_secrets_key.arn
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${var.aws_region}.amazonaws.com"
          }
        }
      }
    ]
  })
}
# ============================================
# IAM POLICY FOR SSM ACCESS
# ===========================================
# Add this inline policy to your existing IAM role
resource "aws_iam_role_policy" "ssm_access" {
  name   = "ec2-ssm-access"
  role   = aws_iam_role.ec2_rds_secrets_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:GetMessages"
        ]
        Resource = "*"
      }
    ]
  })
}

# Also attach the AWS managed policy
resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_rds_secrets_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ============================================
# ATTACH POLICY TO ROLE
# ============================================
resource "aws_iam_role_policy_attachment" "ec2_rds_secrets" {
  role       = aws_iam_role.ec2_rds_secrets_role.name
  policy_arn = aws_iam_policy.ec2_rds_secrets_policy.arn
}

# ============================================
# INSTANCE PROFILE
# ============================================
resource "aws_iam_instance_profile" "ec2_rds_secrets_profile" {
  name = "${var.project_name}-${var.environment}-ec2-rds-secrets-profile"
  role = aws_iam_role.ec2_rds_secrets_role.name
}
