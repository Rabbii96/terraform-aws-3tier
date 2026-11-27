terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state with locking. Create the bucket once, then uncomment:
  # backend "s3" {
  #   bucket       = "my-tf-state-bucket"
  #   key          = "three-tier/dev.tfstate"
  #   region       = "ap-southeast-1"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "three-tier"
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source             = "../../modules/network"
  name               = var.name
  cidr_block         = "10.20.0.0/16"
  az_count           = 2
  single_nat_gateway = true # dev: one NAT to save cost
}

module "compute" {
  source            = "../../modules/compute"
  name              = var.name
  vpc_id            = module.network.vpc_id
  vpc_cidr          = module.network.vpc_cidr
  public_subnet_ids = module.network.public_subnet_ids
  app_subnet_ids    = module.network.app_subnet_ids
  certificate_arn   = var.certificate_arn
  min_size          = 2
  max_size          = 4
  user_data         = file("${path.module}/user_data.sh")
}

module "database" {
  source                = "../../modules/database"
  name                  = var.name
  vpc_id                = module.network.vpc_id
  data_subnet_ids       = module.network.data_subnet_ids
  app_security_group_id = module.compute.app_security_group_id
  multi_az              = false # dev
}
