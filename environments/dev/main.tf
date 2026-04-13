terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — keeps state file safe in S3, uses DynamoDB to prevent conflicts
  backend "s3" {
    bucket         = "aditya-terraform-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Step 1: Build the network layer
module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
  environment  = var.environment
}

# Step 2: Create the S3 bucket for storage
module "s3" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

# Step 3: Create IAM role so EC2 can access S3
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  bucket_arn   = module.s3.bucket_arn
}

# Step 4: Launch EC2 inside the VPC
module "ec2" {
  source       = "../../modules/ec2"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnet_ids[0]
}

# Step 5: Launch RDS in private subnets — not accessible from internet
module "rds" {
  source              = "../../modules/rds"
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.vpc_cidr
  private_subnet_ids  = module.vpc.private_subnet_ids

  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_storage
  deletion_protection  = var.deletion_protection
  skip_final_snapshot  = var.skip_final_snapshot
  backup_retention_days = var.backup_retention
}
