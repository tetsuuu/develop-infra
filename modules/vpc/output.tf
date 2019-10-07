output "vpc_id" {
  value       = aws_vpc.service_vpc.id
  description = "The VPC ID of service environment by"
}

output "public_subnets" {
  value       = aws_subnet.public.*.id
  description = "The public subnet of service environment by"
}

output "private_subnets" {
  value       = aws_subnet.private.*.id
  description = "The private subnet of service environment by"
}
