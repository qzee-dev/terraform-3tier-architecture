resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow MySQL access from internal network"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow all outbound traffic"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  description = "Subnet group for RDS instance"

  subnet_ids = [
    aws_subnet.private_subnet_1a_cidr.id,
    aws_subnet.private_subnet_1b_cidr.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}
resource "aws_db_instance" "mysql" {
  identifier = "mydb"

  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = var.db_password


  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  deletion_protection                 = true
  monitoring_interval                 = 30
  monitoring_role_arn                 = aws_iam_role.rds_monitoring_role.arn
  iam_database_authentication_enabled = true
}
