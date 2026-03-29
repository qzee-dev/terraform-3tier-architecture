#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install SSM Agent (for Ubuntu/Debian)
snap install amazon-ssm-agent --classic
snap start amazon-ssm-agent

# Enable and start SSM Agent service
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Install required dependencies for Ansible
apt-get install -y python3 python3-pip
pip3 install ansible boto3

# ... rest of your Docker/Nginx setup ...
