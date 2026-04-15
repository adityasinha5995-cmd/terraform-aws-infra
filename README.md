# 🏗️ AWS Infrastructure — Terraform

A production-ready Infrastructure as Code (IaC) setup for AWS using Terraform. Designed with modularity, reusability, and environment separation in mind.

## 📁 Project Structure

```
terraform-aws-infra/
├── modules/
│   ├── vpc/         # Networking — VPC, subnets, IGW, route tables
│   ├── ec2/         # Compute — EC2 instances, security groups
│   ├── s3/          # Storage — S3 buckets with versioning & encryption
│   ├── iam/         # Identity — IAM roles & policies
│   └── rds/         # Database — MySQL RDS in private subnets
├── environments/
│   ├── dev/         # Dev environment (small instances, no deletion protection)
│   └── prod/        # Prod environment (larger instances, full protection)
└── .github/
    └── workflows/   # CI/CD — Terraform plan & apply pipelines
```

## 🏛️ Architecture

```
                        ┌─────────────────────────────────┐
                        │           AWS VPC                │
                        │  ┌─────────────┐                │
Internet ──────────────▶│  │ Public      │  EC2 Instance  │
                        │  │ Subnet      │  (Web Server)  │
                        │  └──────┬──────┘                │
                        │         │                        │
                        │  ┌──────▼──────┐                │
                        │  │ Private     │  RDS MySQL      │
                        │  │ Subnet      │  (Database)     │
                        │  └─────────────┘                │
                        └─────────────────────────────────┘
                                    │
                              S3 Bucket
                           (Encrypted Storage)
```

## 🚀 Getting Started

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- An AWS account

### Setup

```bash
# Clone the repo
git clone https://github.com/yourusername/terraform-aws-infra.git
cd terraform-aws-infra

# Navigate to an environment
cd environments/dev

# Initialise Terraform
terraform init

# Preview the plan
terraform plan

# Apply the infrastructure
terraform apply

# When done — destroy everything to avoid charges
terraform destroy
```

## 🌍 Environments

| Setting              | Dev            | Prod           |
|----------------------|----------------|----------------|
| EC2 instance         | t3.micro       | t3.small       |
| RDS instance         | db.t3.micro    | db.t3.small    |
| DB storage           | 20 GB          | 100 GB         |
| Deletion protection  | Off            | On             |
| Final snapshot       | Skipped        | Always taken   |
| Backup retention     | 1 day          | 7 days         |
| VPC CIDR             | 10.0.0.0/16    | 10.1.0.0/16    |

## 🔐 Security Practices

- Remote state stored in S3 with DynamoDB locking
- IAM roles follow least privilege — EC2 gets only the S3 access it needs
- No hardcoded credentials — use tfvars locally, CI/CD secrets in pipelines
- S3 buckets have versioning, AES-256 encryption, and public access blocked
- RDS lives in private subnets — never directly accessible from the internet
- RDS storage encrypted at rest
- Prod has deletion protection enabled to prevent accidents

## 🔄 CI/CD Pipeline

| Trigger            | Action                          |
|--------------------|---------------------------------|
| Pull Request       | terraform plan (preview only)   |
| Merge to main      | terraform apply (deploy)        |

AWS credentials are stored as GitHub Secrets — never in code.

## 📦 Modules Overview

| Module | What it creates |
|--------|----------------|
| vpc    | VPC, public/private subnets, IGW, route tables |
| ec2    | EC2 instance, security group |
| s3     | S3 bucket with versioning, encryption, access block |
| iam    | IAM role, policy, instance profile |
| rds    | MySQL RDS instance, subnet group, security group |

## 🔮 What Would Be Added Next

- Application Load Balancer + Auto Scaling Group for EC2
- CloudWatch alarms and dashboards for monitoring
- ECS/EKS for containerised workloads
- AWS WAF for web application firewall
- Route53 for DNS management
