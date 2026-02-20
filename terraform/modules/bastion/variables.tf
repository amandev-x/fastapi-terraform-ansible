variable "project_name" {
  type        = string
  description = "Name of the Project"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "subnet_id" {
  type        = string
  description = "Public subnet ID for the Bastion"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for the Bastion"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}