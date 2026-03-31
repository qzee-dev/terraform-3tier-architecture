############################################
# SECURITY GROUP FOR INTERFACE ENDPOINTS
############################################
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "vpc-endpoints-sg"
  description = "SG for interface VPC endpoints"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS from VPC resources
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
  }
}

############################################
# GATEWAY ENDPOINT: S3 (FREE)
############################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.public.id
  ]

  tags = {
    Name = "vpce-s3"
  }
}

############################################
# INTERFACE ENDPOINT: SSM
############################################
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-ssm"
  }
}

############################################
# INTERFACE ENDPOINT: SSM MESSAGES
############################################
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-ssmmessages"
  }
}

############################################
# INTERFACE ENDPOINT: EC2 MESSAGES
############################################
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-ec2messages"
  }
}

############################################
# INTERFACE ENDPOINT: CLOUDWATCH LOGS
############################################
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-logs"
  }
}

############################################
# INTERFACE ENDPOINT: SECRETS MANAGER
############################################
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-secretsmanager"
  }
}

############################################
# INTERFACE ENDPOINT: KMS
############################################
resource "aws_vpc_endpoint" "kms" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.kms"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-kms"
  }
}

############################################
# INTERFACE ENDPOINT: EC2 (Optional but Recommended)
############################################
resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "vpce-ec2"
  }
}
