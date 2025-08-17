provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "./modules/vpc"
  project = var.project
  region  = var.aws_region
  cidr    = var.vpc_cidr
}

module "subnets" {
  source      = "./modules/subnets"
  subnet_list = local.subnet_list
  depends_on  = [module.vpc]
}

module "route_table" {
  source           = "./modules/route_table"
  project          = var.project
  vpc_id           = module.vpc.vpc_id
  gateway_id       = module.vpc.gateway_id
  public_subnet_id = local.subnet_ids.nimbus-public_subnet_z1
  depends_on       = [module.vpc, module.subnets]
}

module "ec2-jumpbox" {
  source           = "./modules/ec2-jumpbox"
  project          = var.project
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = local.subnet_ids.nimbus-public_subnet_z1
  instance_type    = var.instance_type
  instance_image   = var.instance_image
  public_ip        = var.public_ip
  depends_on       = [module.vpc, module.subnets, module.route_table]
}
