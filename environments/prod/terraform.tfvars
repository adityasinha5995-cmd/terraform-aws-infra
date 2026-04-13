# ─── Prod Environment Values ─────────────────────────────────────────────────
# Prod uses larger instances, more storage, and stronger protection settings
# db_password must be passed via CI/CD secret — never hardcode in prod

project_name = "myapp"
environment  = "prod"
aws_region   = "us-east-1"

# EC2 — bigger instance for real traffic
instance_type = "t3.small"

# RDS — more storage, deletion protection on, 7 days of backups
db_name             = "appdb"
db_username         = "admin"
db_password         = "" # set via CI/CD secret — never hardcode
db_instance_class   = "db.t3.small"
db_storage          = 100
deletion_protection = true
skip_final_snapshot = false
backup_retention    = 7
