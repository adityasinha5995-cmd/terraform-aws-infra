variable "aws_region" { default = "us-east-1" }
variable "project_name" { default = "myapp" }
variable "environment" { default = "prod" }
variable "vpc_cidr" { default = "10.1.0.0/16" } # different CIDR from dev

variable "instance_type" {
  description = "EC2 instance type — larger for prod"
  default     = "t3.small"
}

variable "db_name" { default = "appdb" }
variable "db_username" { default = "admin" }

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" { default = "db.t3.small" }
variable "db_storage" { default = 100 }

variable "deletion_protection" {
  type    = bool
  default = true # always true in prod — prevents accidents
}

variable "skip_final_snapshot" {
  type    = bool
  default = false # always take a snapshot before destroying prod
}

variable "backup_retention" {
  type    = number
  default = 7 # 7 days of backups in prod
}
