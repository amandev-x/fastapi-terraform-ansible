output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value       = { for k, v in aws_subnet.public_subnets : k => v.id }
  description = "A list of public subnet ids"
}

output "private_subnet_ids" {
  value       = { for k, v in aws_subnet.private_subnets : k => v.id }
  description = "A list of private subnet ids"
}

output "natgateway_id" {
  value       = aws_nat_gateway.main_nat.id
  description = "Nat-gateway ID"
}

