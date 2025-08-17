resource "aws_subnet" "subnets" {
  for_each                = { for idx, subnet in var.subnet_list : idx => subnet}
  vpc_id                  = each.value.vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags                    = each.value.tags
}
