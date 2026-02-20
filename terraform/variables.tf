variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "fastapi-ansible-terraform"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage or prod"
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of AZs"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "ssh_key" {
  type        = string
  description = "SSH key-pair"
  default     = "fastapi-infra-key"
}