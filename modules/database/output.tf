output "db_endpoint" {
  value       = aws_db_instance.service_db.endpoint
  description = "The endpoint of MySQL RDS"
}
