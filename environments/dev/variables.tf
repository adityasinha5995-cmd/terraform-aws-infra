variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project — used as a prefix for all resources"
  default     = "myapp"
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "db_name" {
  description = "Database name"
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username"
  default     = "admin"
}

variable "db_password" {
  description = "Database master password — set via tfvars, never hardcode"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

variable "db_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20
}

variable "deletion_protection" {
  description = "Prevent accidental DB deletion"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "backup_retention" {
  description = "Days to retain automated backups"
  type        = number
  default     = 1
}
