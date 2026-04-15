terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

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

# Step 2: NAT Gateway so private subnets can reach internet
module "nat" {
  source             = "../../modules/nat"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids
}

# Step 3: S3 bucket for storage
module "s3" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

# Step 4: IAM role so EC2 can access S3
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  bucket_arn   = module.s3.bucket_arn
}

# Step 5: Application Load Balancer
module "alb" {
  source            = "../../modules/alb"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# Step 6: Auto Scaling Group — fleet of EC2 instances behind ALB
module "asg" {
  source                = "../../modules/asg"
  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group
  instance_type         = var.instance_type
  min_size              = var.asg_min_size
  max_size              = var.asg_max_size
  desired_capacity      = var.asg_desired_capacity
}

# Step 7: RDS in private subnets
module "rds" {
  source             = "../../modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids

  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_storage
  deletion_protection   = var.deletion_protection
  skip_final_snapshot   = var.skip_final_snapshot
  backup_retention_days = var.backup_retention
}

# Step 8: CloudWatch monitoring and alerts
module "cloudwatch" {
  source                = "../../modules/cloudwatch"
  project_name          = var.project_name
  environment           = var.environment
  asg_name              = module.asg.asg_name
  db_instance_id        = "${var.project_name}-${var.environment}-db"
  scale_up_policy_arn   = module.asg.scale_up_policy_arn
  scale_down_policy_arn = module.asg.scale_down_policy_arn
  alert_email           = var.alert_email
}
