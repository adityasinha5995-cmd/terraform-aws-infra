variable "project_name"       { type = string }
variable "environment"        { type = string }
variable "vpc_id"             { type = string }
variable "vpc_cidr"           { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password — pass this in via tfvars, never hardcode"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "deletion_protection" {
  description = "Prevent accidental deletion of the database"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy (set false in prod)"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "How many days to retain automated backups"
  type        = number
  default     = 7
}
