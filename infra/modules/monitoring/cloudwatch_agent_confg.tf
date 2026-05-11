################################################################################
# CloudWatch Agent Config
################################################################################
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for SSM parameter encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow SSM"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action   = ["kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*", "kms:DescribeKey"]
        Resource = "*"
      },
      {
        Sid    = "Allow Root Account"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name        = "/cloudwatch/agent/ec2/default"
  description = "CloudWatch Agent config for EC2 Docker hosts"
  type        = "SecureString"
  key_id      = aws_kms_key.ssm_key.id

  value = jsonencode({
    metrics = {
      metrics_collected = {
        mem = {
          measurement                 = ["mem_used_percent"]
          metrics_collection_interval = 60
        }
        docker = {
          measurement                 = ["container_restarts"]
          metrics_collection_interval = 60
        }
        net = {
          measurement                 = ["bytes_sent", "bytes_recv"]
          metrics_collection_interval = 60
        }
      }
    }
  })
}

################################################################################
# Cloudwatch Agent ssm policy
################################################################################
resource "aws_iam_policy" "cloudwatch_agent_ssm_policy" {
  name        = "${var.project_name}-${var.environment}-cw-agent-ssm-policy"
  description = "Allow EC2 to read CloudWatch Agent config from SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadCloudWatchAgentConfig"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = aws_ssm_parameter.cloudwatch_agent_config.arn
      }
    ]
  })
}
################################################################################
# Cloudwatch Agent ssm policy attachment
################################################################################

# The attachment to the EC2 instance role should be handled by the IAM module,
# not by the monitoring module, to avoid cross-module resource references.
# resource "aws_iam_role_policy_attachment" "cloudwatch_agent_ssm_attach" {
#   role       = aws_iam_role.ec2_rds_secrets_role.name
#   policy_arn = aws_iam_policy.cloudwatch_agent_ssm_policy.arn
# }
