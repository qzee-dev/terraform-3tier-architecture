# 🏗️ Terraform 3-Tier Architecture

**A complete Infrastructure-as-Code solution for deploying a production-ready, highly available 3-tier architecture on AWS using Terraform.**

---

## 🎯 Quick Overview

This project provisions a secure, scalable 3-tier AWS infrastructure with:
- **Frontend Tier**:Application load balancer (public)
- **Backend Tier**: Nginx in a private subnet hosting web app + API (private with auto-scaling)
- **Database Tier**: RDS PostgreSQL/MySQL (isolated in private subnet)
Think of it as the backbone for any modern web application—handling traffic at the edge, processing business logic, and persisting data securely.
#Internal Build Expression
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/611d0395-5fcb-4623-8a86-9613e4a1f142" />
#External look Represntation
<img width="1536" height="1024" alt="AWS 3-tier architecture diagram" src="https://github.com/user-attachments/assets/07139bda-ff2a-422c-84e8-324f47566f43" />


## Best Practices

- Use remote state (S3 + DynamoDB) for collaboration
- Store secrets in AWS Secrets Manager
- Apply least-privilege IAM role

## Terraform 3-Tier Architecture summary  🚀
Here’s the **final, blended `README.md`** with a **Mermaid diagram** showing the CI/CD + rollout flow. This version is copy‑paste ready and GitHub‑standard:

```markdown
## Terraform 3-Tier Architecture 🚀

This project delivers a **ready-made DevOps implementation** with baked AMIs and GitHub Flow:

- **Baked AMI approach** → EC2 instances are launched from pre-configured AMIs for consistency.  
- **GitHub Flow** → Branch → Pull Request → Merge → Main.  
- **CI/CD pipelines** → Automated security and compliance checks run on every PR and push.  
- **Manual deployment workflow** → Infrastructure deployment is triggered manually via GitHub Actions dispatch.  
- **Safe rollout strategies** → Old EC2 instances are only terminated once new ones are healthy.  

Together, this ensures **secure, scalable, production-ready infrastructure** with minimal manual intervention.

---

## ✨ Key Features

| Feature              | Benefit                                           |
|----------------------|---------------------------------------------------|
| Multi-AZ Deployment  | High availability & disaster recovery             |
| Auto-Scaling         | Automatically scales based on demand              |
| Load Balancing       | Distributes traffic evenly across instances       |
| Private Subnets      | Isolates backend and database from internet       |
| VPC Endpoints        | Secure, private access to AWS services (S3, Secrets Manager) |
| IAM Roles & Policies | Least-privilege access for EC2 instances          |
| RDS Database         | Managed, scalable relational database             |
| VPC Flow Logs        | Network monitoring and troubleshooting            |
| ALB Logging          | Track all incoming requests                       |
| Vault Integration    | Secure credential management with HashiCorp Vault |
| CI/CD Ready          | GitHub Actions workflows included                 |
| Baked AMI            | Pre-configured images ensure consistent deployments |

---

## 📋 Prerequisites

- ✅ Terraform v1.0 or higher  
- ✅ AWS CLI configured with credentials  
- ✅ AWS Account with permissions (EC2, RDS, VPC, IAM, S3)  
- ✅ Git for version control  
- ✅ HashiCorp Vault (optional, for secure credential management)  

Verify setup:

```bash
terraform --version
aws --version
aws sts get-caller-identity
```

---

## 📁 Project Structure

```plaintext
terraform-3tier-architecture/
├── infra/
│   ├── provider.tf
│   ├── variable.tf
│   ├── terraform.tfvars
│   ├── main.tf
│   ├── natgateway.tf
│   ├── vpc_endpoint.tf
│   ├── alb.tf
│   ├── alb-logs.tf
│   ├── web_launch_template.tf
│   ├── web-asg.tf
│   ├── ec2_sg.tf
│   ├── ec2-secrets-role.tf
│   ├── ec2-rds-access-role.tf
│   ├── rds.tf
│   ├── s3.tf
│   ├── vpc-flow-logs.tf
│   ├── output.tf
│   ├── ami_rollout_v1.tf
│   ├── ami_rollout_auto_scal_up.tf
│   └── ansible/
├── .github/workflows/
│   ├── Checkov-ci.yaml
│   ├── gitleaks.yaml
│   └── infra-create.yaml
└── README.md
```

---

## 🔍 CI/CD Workflow

- **DevOps/Sre workflow** → Branch → PR → Merge → Main.  
- **Automated checks**:  
  - **Gitleaks** → scans every PR/push for secrets.  
  - **Checkov** → validates Terraform security best practices on every PR/push.  
- **Deployment**:  
  - **Manual dispatch only** → Infrastructure deployment workflow (`infra-create.yaml`) must be triggered manually.  
  - Supports environments: `dev`, `staging`, `prod`.  

---

## 🔄 Rollout Strategies (Baked AMI Deployment)

This project uses **baked AMIs** for application deployment. The rollout strategy ensures **safe, continuous delivery** without downtime:

### Refresh Rollout
- New EC2 instances are launched from the latest baked AMI.  
- Old EC2 instances are **only terminated once new instances are healthy**.  
- Health checks are performed via the ALB target group.  

### Health Thresholds
- **Minimum target = 3 instances**  
  → At least **75% health** must be achieved before terminating any old EC2.  

- **Minimum target = 2 instances**  
  → A temporary **third Auto Scaling Group** is created to add capacity.  
  → At least **50% health** must be achieved before terminating old EC2.  

### Deployment Flow
1. Launch new EC2 instances with baked AMI.  
2. Wait until health checks pass (ALB target group).  
3. Only then terminate old EC2 instances.  
4. Maintain minimum health thresholds throughout rollout.  
---
## 📊 CI/CD + Rollout Flow (Diagram)
<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/f41f180e-29d3-4b5e-999a-59cd3583ae5e" />

## 📊 Monitoring & Logging
- ALB access logs → S3 bucket  
- VPC Flow Logs → CloudWatch  

```bash
aws logs describe-log-groups
aws logs tail /aws/vpc/flowlogs --follow
```

---

## 🐛 Troubleshooting

- **terraform init fails** → Update AWS credentials  
- **Instances not launching** → Check ALB target group health  
- **RDS connection refused** → Verify security group rules  
- **State lock error** → `terraform force-unlock <LOCK_ID>`

---

## 💬 Support

- Issues → GitHub Issues  
- Discussions → GitHub Discussions  

---

## 🎓 Learn More

- Infrastructure-as-Code (IaC)  
- AWS Cloud Architecture  
- DevOps & CI/CD  
- Terraform Best Practices  
- Network Security  

---

**This project is a baked AMI, GitHub Flow–driven, CI/CD integrated DevOps implementation.**  
- **Secrets scanning (Gitleaks)** runs automatically on PRs and pushes.  
- **Security checks (Checkov)** run automatically on PRs and pushes.  
- **Deployment** is **manual dispatch only**, ensuring controlled release.  
- **Rollout strategy** ensures safe cutover with health thresholds and no downtime.  

_Last Updated: April 5, 2026_
```

---
