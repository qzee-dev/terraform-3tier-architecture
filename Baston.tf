# Security group for bastion
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_OFFICE_IP/32"]  # restrict SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Bastion host EC2
resource "aws_instance" "bastion" {
  ami           = "ami-xxxxxxxx"  # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id  # public subnet
  key_name      = "your-keypair"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}
