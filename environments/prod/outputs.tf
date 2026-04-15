output "vpc_id" { value = module.vpc.vpc_id }
output "public_ip" { value = module.ec2.public_ip }
output "bucket_id" { value = module.s3.bucket_id }
output "db_endpoint" { value = module.rds.db_endpoint }
output "db_port" { value = module.rds.db_port }
