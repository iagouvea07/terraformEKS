terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

module "iam" {
  source = "../../modules/vpc"
  global = var.global
  vpc    = var.vpc
  eks    = var.eks
}