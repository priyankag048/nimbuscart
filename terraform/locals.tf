locals {
  subnet_list = [for detail in var.subnet_details : {
    id                      = detail.id
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = detail.cidr
    map_public_ip_on_launch = strcontains(detail.id, "public") ? true : null
    availability_zone       = strcontains(detail.id, "z1") ? "${var.aws_region}${var.aws_zones.zone1}" : "${var.aws_region}${var.aws_zones.zone2}"
    tags                    = { Name = "${var.project}-${detail.id}" }
  }]

  public_subnet_id = [
    for subnet in module.subnets.subnet_ids : subnet.id
    if strcontains((subnet.name), "public")
  ][0]
  private_subnet_ids = [
    for subnet in module.subnets.subnet_ids : subnet.id
    if strcontains((subnet.name), "private")
  ]
}

