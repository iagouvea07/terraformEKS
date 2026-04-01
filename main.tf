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
  cluster_oidc = module.eks.oidc_cluster
}

module "vpc" {
  source = "./modules/vpc"
  global = var.global
  vpc    = var.vpc
  eks    = var.eks
}

module "eks" {
  source  = "./modules/eks"
  global  = var.global
  eks     = var.eks
  subnets = module.vpc.subnets
  roles    = module.iam.roles
}

module "rds" {
  source            = "./modules/rds"
  global            = var.global
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.subnets.public_subnet_id
  rds               = var.rds
}
