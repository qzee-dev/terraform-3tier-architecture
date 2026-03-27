############################################
# EC2 INSTANCE
############################################
resource "aws_instance" "webserver1" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  key_name               = "my-keypair-name"

  associate_public_ip_address = false

  monitoring    = true
  ebs_optimized = true

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  tags = {
    Name = "web-EC2"
  }
}

