# 🏗️ AWS Infrastructure — Terraform

A production-ready Infrastructure as Code (IaC) setup for AWS using Terraform. Designed with modularity, reusability, and environment separation in mind.

## 📁 Project Structure

```
terraform-aws-infra/
├── modules/
│   ├── vpc/         # Networking — VPC, subnets, IGW, route tables
│   ├── ec2/         # Compute — EC2 instances, security groups
│   ├── s3/          # Storage — S3 buckets with versioning & encryption
│   └── iam/         # Identity — IAM roles & policies
├── environments/
│   ├── dev/         # Dev environment config
│   └── prod/        # Prod environment config
└── .github/
    └── workflows/   # CI/CD — Terraform plan & apply pipelines
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
```

## 🌍 Environments

| Environment | Region      | Purpose              |
|-------------|-------------|----------------------|
| dev         | us-east-1   | Development & testing |
| prod        | us-east-1   | Production workloads  |

## 🔐 Security Practices

- Remote state stored in S3 with DynamoDB locking
- IAM roles follow least privilege principle
- No hardcoded credentials — uses AWS CLI profiles or environment variables
- S3 buckets have versioning and AES-256 encryption enabled by default

## 🔄 CI/CD Pipeline

On every Pull Request → `terraform plan` runs automatically  
On merge to `main` → `terraform apply` runs automatically

## 📦 Modules Overview

### VPC Module
Creates a full networking layer: VPC, public/private subnets, Internet Gateway, NAT Gateway, and route tables.

### EC2 Module
Provisions EC2 instances with configurable AMI, instance type, and security groups.

### S3 Module
Creates S3 buckets with versioning, encryption, and public access blocking.

### IAM Module
Creates IAM roles and attaches policies for secure service-to-service access.
