output "alb_dns_name"  { value = module.alb.alb_dns_name }
output "bucket_id"     { value = module.s3.bucket_id }
output "db_endpoint"   { value = module.rds.db_endpoint }
output "nat_public_ip" { value = module.nat.nat_public_ip }
output "asg_name"      { value = module.asg.asg_name }
output "dashboard"     { value = module.cloudwatch.dashboard_name }
