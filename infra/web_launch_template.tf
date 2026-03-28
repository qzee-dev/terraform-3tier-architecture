############################################
# Launch Template for ASG + Docker + Nginx
############################################
resource "aws_launch_template" "web_lt" {
  name_prefix   = "webserver-"
  image_id      = var.ec2_ami_id       # Use your AMI with OS of choice
  instance_type = var.instance_type1
  key_name      = "my-keypair-name"

# IAM permissions for instance

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_rds_secrets_profile.name
  }

 # Network interface security
  vpc_security_group_ids       = [aws_security_group.ec2_sg.id]
 
  associate_public_ip_address = false   # Private subnet, no public IP
  monitoring                  = true
  ebs_optimized               = true

# EC2 Instance Metadata Service hardening
  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }


 # Storage configuration

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

 # Application initialization # User data for Docker + Nginx + Docker Compose setup
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    secret_name   = var.secret_name
    region        = var.aws_region
    webapp_image  = var.webapp_docker_image
    api_image     = var.api_docker_image
  }))

# Resource tagging
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "webserver-asg"
    }
  }
}
