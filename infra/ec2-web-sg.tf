############################################
# SECURITY GROUP FOR EC2
############################################
resource "aws_security_group" "sg1" {
  name        = "web_sg1"
  description = "Allow TLS,http,ssh trafic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow HTTP traffic from the internet"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS traffic from the internet"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH traffic from this network"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "10.0.0.0/24"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic from this block"
}