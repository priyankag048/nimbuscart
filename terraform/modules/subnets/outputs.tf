output "subnet_ids" {
  value = [for subnet in aws_subnet.subnets: {
    id = subnet.id
    name = subnet.tags_all.Name
  }]
}