output "vpc_id" {
  value       = aws_vpc.service_vpc.id
  description = "The VPC ID of service environment by"
}

output "cidr_block" {
  value       = aws_vpc.service_vpc.cidr_block
  description = "The VPC cidr block"
}

output "public_subnets" {
  value       = aws_subnet.public.*.id
  description = "The public subnet of service environment by"
}

output "private_subnets" {
  value       = aws_subnet.private.*.id
  description = "The private subnet of service environment by"
}
