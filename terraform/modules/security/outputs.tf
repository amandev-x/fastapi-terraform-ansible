output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id
}

output "bastion_security_group_id" {
  description = "Security group ID of the Bastion"
  value       = aws_security_group.bastion_sg.id
}

output "ec2_security_group_id" {
  description = "Security group ID of the EC2"
  value       = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  description = "Security group ID of the RDS"
  value       = aws_security_group.rds_sg.id
}