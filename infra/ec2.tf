############################################
# EC2 INSTANCES
############################################

# Web1
resource "aws_instance" "webserver1" {
  ami                    = var.ami1
  instance_type          = var.instance_type1
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.alb_sg.id] # Only ALB can reach
  key_name               = "my-keypair-name"

  associate_public_ip_address = false
  monitoring                  = true
  ebs_optimized               = true

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
    Name = "web1"
  }
}

# Web2
resource "aws_instance" "webserver2" {
  ami                    = var.ami2
  instance_type          = var.instance_type2
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.alb_sg.id]
  key_name               = "my-keypair-name"

  associate_public_ip_address = false
  monitoring                  = true
  ebs_optimized               = true

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
    Name = "web2"
  }
}

############################################
# ATTACH INSTANCES TO ALB TARGET GROUP
############################################

# Webserverb1 Target Group Attachment
resource "aws_lb_target_group_attachment" "webserver1_tg" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

# Webserver2 Target Group Attachment
resource "aws_lb_target_group_attachment" "webserver2_tg" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}
