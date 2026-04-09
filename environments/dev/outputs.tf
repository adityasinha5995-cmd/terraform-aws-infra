output "vpc_id"    { value = module.vpc.vpc_id }
output "public_ip" { value = module.ec2.public_ip }
output "bucket_id" { value = module.s3.bucket_id }
