
resource "aws_instance" "webserver1" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name               = "my-keypair-name"

  associate_public_ip_address = true

  tags = {
    Name = "web-EC2"
  
}
}

resource "aws_s3_bucket" "bucket1"{
  bucket = "test-bucket-1-qzee-project"


versioning    {
    enabled = true
  }


  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
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
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls"{
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

