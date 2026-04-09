################################################################################
CloudWatch Agent Config
################################################################################
resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name        = "/cloudwatch/agent/ec2/default"
  description = "CloudWatch Agent config for EC2 Docker hosts"
  type        = "String"

  value = jsonencode({
    metrics = {
      metrics_collected = {
        mem = {
          measurement = ["mem_used_percent"]
          metrics_collection_interval = 60
        }
        docker = {
          measurement = ["container_restarts"]
          metrics_collection_interval = 60
        }
        net = {
          measurement = ["bytes_sent", "bytes_recv"]
          metrics_collection_interval = 60
        }
      }
    }
  })
}

################################################################################
Cloudwatch Agent  ssm   policy
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
Cloudwatch Agent  ssm   policy is attached to the ec2_rds_secret_role
################################################################################

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_ssm_attach" {
  role       = aws_iam_role.ec2_rds_secrets_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_ssm_policy.arn
}
