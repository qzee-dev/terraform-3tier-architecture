# Fetch Foundation Layer Outputs
# This creates a zero-cost reference to the foundation state file
data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket         = "your-org-tfstate"
    key            = "foundation/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

# Convert foundation outputs to locals for easy use
locals {
  vpc_id           = data.terraform_remote_state.foundation.outputs.vpc_id
  subnet1_id       = data.terraform_remote_state.foundation.outputs.subnet1_id
  subnet2_id       = data.terraform_remote_state.foundation.outputs.subnet2_id
  app_tg_arn       = data.terraform_remote_state.foundation.outputs.app_tg_arn
  ec2_sg_id        = data.terraform_remote_state.foundation.outputs.ec2_sg_id
  iam_profile_name = data.terraform_remote_state.foundation.outputs.iam_profile_name
}


