locals {
  environment = "staging"
}

module "vpc" {
  source = "../../modules/vpc"

  cidr_block  = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  environment = local.environment
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type = "t4g.nano"
  subnet_ids    = module.vpc.subnet_ids
  environment    = local.environment
}

module "security_groups" {
  source = "../../modules/security_groups"

  vpc_id      = module.vpc.vpc_id
  environment = local.environment
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  security_group_id = module.security_groups.web_sg_id
  subnet_ids        = module.vpc.subnet_ids
  environment       = local.environment
}
