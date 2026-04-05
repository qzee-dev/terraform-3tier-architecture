# 🏗️ Terraform 3-Tier Architecture

**A complete Infrastructure-as-Code solution for deploying a production-ready, highly available 3-tier architecture on AWS using Terraform.**

---

## 🎯 Quick Overview

This project provisions a secure, scalable 3-tier AWS infrastructure with:
- **Frontend Tier**: Web servers behind a load balancer (public)
- **Backend Tier**: Application servers (private with auto-scaling)
- **Database Tier**: RDS PostgreSQL/MySQL (isolated in private subnet)

Think of it as the backbone for any modern web application—handling traffic at the edge, processing business logic, and persisting data securely.

---

## 📊 Architecture Diagram
```mermaid
flowchart LR
    Users((👥 Users / Internet))
    IGW[Internet Gateway]
    
    subgraph Public["🌐 Public Tier"]
        ALB[Application Load Balancer]     
    end
     subgraph Private_App["🔒 Nginx/proxy Private App Tier"]
       FE[Frontend Web Servers]
    subgraph Private_App["🔒 Private App Tier"]
        BE[Backend API Servers<br/>Auto-Scaling Group]
    end
    
    subgraph Private_DB["🔐 Private Database Tier"]
        DB[(RDS Database)]
    end
    
    Users -->|Internet Traffic| IGW
    IGW --> ALB
    ALB -->|Route Traffic| FE
    FE -->|Internal API Calls| BE
    BE -->|Query Data| DB
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
- EC2 Public ip

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
