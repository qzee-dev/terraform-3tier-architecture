# 🏗️ Terraform 3-Tier Architecture

**A complete Infrastructure-as-Code solution for deploying a production-ready, highly available 3-tier architecture on AWS using Terraform.**

---

## 🎯 Quick Overview

This project provisions a secure, scalable 3-tier AWS infrastructure with:
- **Frontend Tier**:Application load balancer (public)
- **Backend Tier**: Nginx in a private subnet hosting web app + API (private with auto-scaling)
- **Database Tier**: RDS PostgreSQL/MySQL (isolated in private subnet)

Think of it as the backbone for any modern web application—handling traffic at the edge, processing business logic, and persisting data securely.
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/611d0395-5fcb-4623-8a86-9613e4a1f142" />


## Best Practices
- Use remote state (S3 + DynamoDB) for collaboration
- Store secrets in AWS Secrets Manager
- Apply least-privilege IAM role

# Terraform 3-Tier Architecture summary  🚀


