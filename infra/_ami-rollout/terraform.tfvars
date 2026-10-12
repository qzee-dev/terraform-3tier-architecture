aws_region      = "us-east-1"
new_ami_id      = "ami-0c02fb55956c7d31"  # Update this for each deployment
app_version     = "v1.0.0"                # Update this for each version
instance_type   = "t2.micro"
environment     = "prod"
min_healthy_percentage = 66
max_healthy_percentage = 150
instance_warmup_seconds = 120
