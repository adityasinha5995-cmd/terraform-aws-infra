project_name = "myapp"
environment  = "dev"
aws_region   = "us-east-1"

# EC2 / ASG
instance_type        = "t3.micro"
asg_min_size         = 1
asg_max_size         = 4
asg_desired_capacity = 2

# RDS
db_name             = "appdb"
db_username         = "admin"
db_password         = "MyDevPass123"
db_instance_class   = "db.t3.micro"
db_storage          = 20
deletion_protection = false
skip_final_snapshot = true
backup_retention    = 1

# Alerts
alert_email = "adityasinha5995@gmail.com"
