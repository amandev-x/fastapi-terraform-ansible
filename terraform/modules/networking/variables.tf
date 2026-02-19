variable "project_name" {
  type        = string
  description = "Name of the Project"
  default     = "fastapi-ansible-terraform"
}

variable "environment" {
  type        = string
  description = "Name of the Environment"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage or prod"
  }
}

variable "region" {
  type        = string
  description = "AWS Region name"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR Block for the VPC"
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable dns support"
  default     = false
}

variable "enable_dns_hostname" {
  type        = bool
  description = "Enable dns hostname"
  default     = false
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of AZs"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}




