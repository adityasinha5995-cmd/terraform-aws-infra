output "db_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "db_name" {
  value = aws_db_instance.rds.db_name
}

output "db_port" {
  value = aws_db_instance.rds.port
}
