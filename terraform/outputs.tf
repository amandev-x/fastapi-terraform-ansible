output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID of the VPC"
}

output "vpc_cidr" {
  value = module.networking.vpc_cidr
}
output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
  description = "A list of public subnet ids"
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids
  description = "A list of private subnet ids"
}

output "natgateway_id" {
    value = module.networking.natgateway_id
    description = "ID of the Nat-Gateway"
}
