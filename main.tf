terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

// Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

// Configure Vault Provider
// Remember to export Address and Token 
provider "vault" {
}

module "role" {
  source = "./modules/role"

  env_ci = var.env_ci
  vault_env = var.vault_env
}

variable "env_ci" {}
variable "aws_region" {}
variable "vault_env" {}