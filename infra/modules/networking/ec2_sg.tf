resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow traffic from ALB to EC2"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic ONLY from ALB
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # (Optional) Allow HTTPS if your app uses it internally
  # ingress {
  #   description     = "HTTPS from ALB"
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # Allow outbound traffic (needed for updates, pulling Docker images, etc.)
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP outbound"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound"
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
    description = "Allow MySQL to RDS"
  }

  tags = {
    Name = "ec2-sg"
  }
}
