resource "aws_launch_template" "web_lt" {
  name_prefix   = "webserver-"
  image_id      = var.ami1
  instance_type = var.instance_type1
  key_name      = "my-keypair-name"

  vpc_security_group_ids = [aws_security_group.alb_sg.id]

  monitoring = true
  ebs_optimized = true

  associate_public_ip_address = false

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webserver-asg"
    }
  }
}
