terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = "11.0.0.0/16"
  availability_zones = var.availability_zones
  public_subnets     = ["11.0.1.0/24", "11.0.2.0/24"]
  private_subnets    = ["11.0.10.0/24", "11.0.11.0/24"]
}

# Security Group Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  vpc_cidr     = module.networking.vpc_cidr
}

# Bastion Host Module
module "bastion" {
  source = "./modules/bastion"

  project_name = var.project_name
  environment  = var.environment
  # Use values() to turn objects/maps into list, then access the first element with [0] 
  subnet_id         = values(module.networking.public_subnet_ids)[0]
  security_group_id = module.security.bastion_security_group_id
  key_name          = var.ssh_key
}