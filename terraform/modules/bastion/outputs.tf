output "bastion_public_ip" {
  value       = aws_instance.bastion_host.public_ip
  description = "Public IP of Bastion Host"
}

output "bastion_id" {
  value       = aws_instance.bastion_host.id
  description = "ID of the Bastion Host"
}