variable "aws_region"   { default = "us-east-1" }
variable "project_name" { default = "myapp" }
variable "environment"  { default = "dev" }
variable "vpc_cidr"     { default = "10.0.0.0/16" }

variable "instance_type" { default = "t3.micro" }

# ASG settings
variable "asg_min_size"        { default = 1 }
variable "asg_max_size"        { default = 4 }
variable "asg_desired_capacity" { default = 2 }

# RDS settings
variable "db_name"     { default = "appdb" }
variable "db_username" { default = "admin" }
variable "db_password" { type = string; sensitive = true }
variable "db_instance_class"   { default = "db.t3.micro" }
variable "db_storage"          { default = 20 }
variable "deletion_protection" { default = false }
variable "skip_final_snapshot" { default = true }
variable "backup_retention"    { default = 1 }

# CloudWatch
variable "alert_email" {
  description = "Email to receive CloudWatch alerts"
  type        = string
  default     = "your@email.com"
}
