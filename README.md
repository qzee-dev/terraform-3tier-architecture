# 🏗️ Terraform 3-Tier Architecture

**A complete Infrastructure-as-Code solution for deploying a production-ready, highly available 3-tier architecture on AWS using Terraform.**

---

## 🎯 Quick Overview

This project provisions a secure, scalable 3-tier AWS infrastructure with:
- **Frontend Tier**:Application load balancer (public)
- **Backend Tier**: Nginx in a private subnet hosting web app + API (private with auto-scaling)
- **Database Tier**: RDS PostgreSQL/MySQL (isolated in private subnet)

Think of it as the backbone for any modern web application—handling traffic at the edge, processing business logic, and persisting data securely.

---

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/fd37697c-7f58-47a4-99cd-11e59d343b32" />

```

## Prerequisites
- Terraform v1.x
- AWS CLI configured with credentials
- An AWS account
## Usage
1. Initialize Terraform:
   terraform init

2. Preview changes:
   terraform plan

3. Apply configuration:
   terraform apply

4. Destroy resources:
   terraform destroy

## Outputs
- Load Balancer DNS
- Database Endpoint


## Best Practices
- Use remote state (S3 + DynamoDB) for collaboration
- Store secrets in AWS Secrets Manager
- Apply least-privilege IAM roles


    BE --> DB
```
## Networking Connection
Internet
   │
Internet Gateway
   │
Public Route Table
   │
 ┌───────────────┬───────────────┐
 │               │
Subnet1          Subnet2
(Public)         (Public)
│
NAT Gateway
│
Private Route Table
│
 ┌───────────────┬───────────────┐
 │               │
Subnet3          Subnet4
(Private)        (Private)
