# ─── Dev Environment Values ──────────────────────────────────────────────────
# These override the defaults in variables.tf for the dev environment
# Never commit real passwords — use AWS Secrets Manager or CI/CD secrets in prod

project_name = "myapp"
environment  = "dev"
aws_region   = "us-east-1"

# EC2 — small instance for dev
instance_type = "t3.micro"

# RDS — smallest size for dev, no deletion protection needed
db_name             = "appdb"
db_username         = "admin"
db_password         = "dev-password-change-me" # replace before running
db_instance_class   = "db.t3.micro"
db_storage          = 20
deletion_protection = false
skip_final_snapshot = true
backup_retention    = 1
