output "vpc_id" {
  value = aws_vpc.nimbus_vpc.id
}
output "gateway_id" {
  value = aws_internet_gateway.igw.id
}
