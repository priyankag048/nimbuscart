output vpc_id {
    value = module.vpc.vpc_id
}

output "gateway_id" {
  value = module.vpc.gateway_id
}

output "jumpbox_ip" {
    value = module.ec2-jumpbox.jumpbox_public_ip
}