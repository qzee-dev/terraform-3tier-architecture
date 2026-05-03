########################################
# IAM Role → ec2-secrets-role 
####################################
resource "aws_iam_role" "ec2_secrets_role" {
  name = "ec2-secrets-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}
########################################
# IAM Policy → secretsmanager-rds-access
####################################
resource "aws_iam_policy" "secrets_policy" {
  name        = "secretsmanager-rds-access"
  description = "Allow EC2 to read RDS secrets"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue"],
      Resource = "arn:aws:secretsmanager:REGION:ACCOUNT_ID:secret:my-rds-credentials-*"
    }]
  })
}
########################################
# IAM Policy attachement
####################################
resource "aws_iam_role_policy_attachment" "attach_secrets" {
  role       = aws_iam_role.ec2_secrets_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}
########################################
# IAM Policy attachement
####################################
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_secret_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
########################################
# IAM Instance Profile → ec2-secrets-profile
####################################
resource "aws_iam_instance_profile" "ec2_secrets_profile" {
  name = "ec2-secrets-profile"
  role = aws_iam_role.ec2_secrets_role.name
}
