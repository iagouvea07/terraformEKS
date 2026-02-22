terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = var.global.region
  profile = var.global.profile
}

module "iam" {
  source = "./modules/iam"
  global = var.global
}

module "vpc" {
  source = "./modules/vpc"
  global = var.global
  vpc    = var.vpc
}

module "eks" {
  source  = "./modules/eks"
  global  = var.global
  eks     = var.eks
  subnets = module.vpc.subnets
  roles    = module.iam.roles
}