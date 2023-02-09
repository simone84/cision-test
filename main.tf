terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "role" {
  source = "./modules/role"

  env_ci = var.env_ci
  account_id = var.account_id
}

variable "env_ci" {}
variable "account_id" {}
variable "aws_region" {}