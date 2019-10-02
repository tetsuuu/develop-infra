output "db_endpoint" {
  value = aws_db_instance.service-db.endpoint
  description = "The endpoint of MySQL RDS"
}
