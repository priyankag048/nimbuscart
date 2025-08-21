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
  public_subnet_id = local.public_subnet_id
  depends_on       = [module.vpc, module.subnets]
}

module "ec2-jumpbox" {
  source           = "./modules/ec2-jumpbox"
  project          = var.project
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = local.public_subnet_id
  instance_type    = var.instance_type
  instance_image   = var.instance_image
  public_ip        = var.public_ip
  depends_on       = [module.vpc, module.subnets, module.route_table]
}

module "messaging" {
  source     = "./modules/messaging"
  sns_topic  = var.sns_topic
  depends_on = [module.vpc, module.subnets, module.route_table]
}

# module "eks" {
#   source             = "./modules/eks"
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = local.private_subnet_ids
#   cluster            = var.cluster
#   tags               = var.tags
#   depends_on         = [module.vpc, module.subnets, module.route_table]
# }

# module "rds" {
#   source             = "./modules/rds"
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = local.private_subnet_ids
#   eks_node_sg_id     = module.eks.node_sg_id
#   tags               = var.tags
#   depends_on         = [module.vpc, module.subnets, module.route_table]
# }

module "s3" {
  source  = "./modules/s3"
  project = var.project
}

module "lambda" {
  source                    = "./modules/lambda"
  project                   = var.project
  bucket_name               = module.s3.bucket_name
  order_response_topic_arn  = local.topic_list["nimbus-order-response"]
  order_finalized_topic_arn = local.topic_list["nimbus-order-finalized"]
}
