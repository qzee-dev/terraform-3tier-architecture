# 🏗️ Terraform 3-Tier Architecture

**A complete Infrastructure-as-Code solution for deploying a production-ready, highly available 3-tier architecture on AWS using Terraform.**

---

## 🎯 Quick Overview

This project provisions a secure, scalable 3-tier AWS infrastructure with:
- **Frontend Tier**:Application load balancer (public)
- **Backend Tier**: Nginx in a private subnet hosting web app + API (private with auto-scaling)
- **Database Tier**: RDS PostgreSQL/MySQL (isolated in private subnet)

Think of it as the backbone for any modern web application—handling traffic at the edge, processing business logic, and persisting data securely.
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="900" viewBox="0 0 1200 900">
  <style>
    .box { fill: #f4f4f4; stroke: #333; stroke-width: 2; rx: 10; ry: 10; }
    .decision { fill: #fff3cd; stroke: #333; stroke-width: 2; }
    .arrow { stroke: #333; stroke-width: 2; marker-end: url(#arrowhead); }
    text { font-family: Arial, sans-serif; font-size: 14px; text-anchor: middle; }
  </style>

  <defs>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" 
            refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" />
    </marker>
  </defs>

  <!-- Nodes -->
  <rect class="box" x="450" y="20" width="300" height="40"/>
  <text x="600" y="45">👨‍💻 SRE/DevOps creates branch</text>

  <rect class="box" x="450" y="80" width="300" height="40"/>
  <text x="600" y="105">🔀 Pull Request</text>

  <rect class="box" x="200" y="150" width="250" height="40"/>
  <text x="325" y="175">🕵️‍♂️ Gitleaks Scan</text>

  <rect class="box" x="750" y="150" width="250" height="40"/>
  <text x="875" y="175">🛡️ Checkov Scan</text>

  <polygon class="decision" points="325,230 375,270 325,310 275,270"/>
  <text x="325" y="275">Secrets?</text>

  <polygon class="decision" points="875,230 925,270 875,310 825,270"/>
  <text x="875" y="275">Issues?</text>

  <rect class="box" x="250" y="330" width="150" height="40"/>
  <text x="325" y="355">❌ Fail PR</text>

  <rect class="box" x="800" y="330" width="150" height="40"/>
  <text x="875" y="355">❌ Fail PR</text>

  <rect class="box" x="500" y="330" width="200" height="40"/>
  <text x="600" y="355">✅ Merge to Main</text>

  <rect class="box" x="450" y="400" width="300" height="40"/>
  <text x="600" y="425">🚀 Manual Deployment</text>

  <rect class="box" x="450" y="460" width="300" height="40"/>
  <text x="600" y="485">💻 Launch EC2 (AMI)</text>

  <rect class="box" x="450" y="520" width="300" height="40"/>
  <text x="600" y="545">🔍 ALB Health Check</text>

  <polygon class="decision" points="600,600 650,640 600,680 550,640"/>
  <text x="600" y="645">≥75%?</text>

  <rect class="box" x="350" y="700" width="200" height="40"/>
  <text x="450" y="725">🗑️ Terminate Old EC2</text>

  <rect class="box" x="650" y="700" width="200" height="40"/>
  <text x="750" y="725">⏱️ Retry</text>

  <rect class="box" x="450" y="780" width="300" height="40"/>
  <text x="600" y="805">🎉 Deployment Complete</text>

  <!-- Arrows -->
  <line class="arrow" x1="600" y1="60" x2="600" y2="80"/>
  <line class="arrow" x1="600" y1="120" x2="325" y2="150"/>
  <line class="arrow" x1="600" y1="120" x2="875" y2="150"/>

  <line class="arrow" x1="325" y1="190" x2="325" y2="230"/>
  <line class="arrow" x1="875" y1="190" x2="875" y2="230"/>

  <line class="arrow" x1="325" y1="310" x2="325" y2="330"/>
  <line class="arrow" x1="875" y1="310" x2="875" y2="330"/>

  <line class="arrow" x1="375" y1="270" x2="500" y2="350"/>
  <line class="arrow" x1="825" y1="270" x2="700" y2="350"/>

  <line class="arrow" x1="600" y1="370" x2="600" y2="400"/>
  <line class="arrow" x1="600" y1="440" x2="600" y2="460"/>
  <line class="arrow" x1="600" y1="500" x2="600" y2="520"/>
  <line class="arrow" x1="600" y1="560" x2="600" y2="600"/>

  <line class="arrow" x1="580" y1="680" x2="450" y2="700"/>
  <line class="arrow" x1="620" y1="680" x2="750" y2="700"/>

  <line class="arrow" x1="450" y1="740" x2="600" y2="780"/>
  <line class="arrow" x1="750" y1="740" x2="600" y2="780"/>

</svg>

```

## Best Practices
- Use remote state (S3 + DynamoDB) for collaboration
- Store secrets in AWS Secrets Manager
- Apply least-privilege IAM role

# Terraform 3-Tier Architecture summary  🚀
Here’s the **final, blended `README.md`** with a **Mermaid diagram** showing the CI/CD + rollout flow. This version is copy‑paste ready and GitHub‑standard:

```markdown
# Terraform 3-Tier Architecture 🚀

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

- **Sre workflow** → Branch → PR → Merge → Main.  
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
https://chatgpt.com/s/m_69d278893f448191a15c8f0dfbad98c6
---

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

## 🤝 Contributing

1. Fork the repository  
2. Create a feature branch  
3. Commit changes  
4. Push branch  
5. Open a Pull Request  

Pull Request Checklist:
- `terraform fmt -recursive`  
- `terraform validate`  
- Checkov scan passes  
- Gitleaks scan passes  
- Documentation updated  

---

---

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

**Happy Infrastructure Coding! 🚀**

_Last Updated: April 5, 2026_
```

---

