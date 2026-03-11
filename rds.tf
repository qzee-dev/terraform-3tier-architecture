resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.subnet3.id,
    aws_subnet.subnet4.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

resource "aws_db_instance" "mysql" {
  identifier = "mydb"

  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "password123"

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
}
  
}
