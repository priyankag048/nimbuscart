variable "subnet_list" {
  type = list(object({
    vpc_id = string
    cidr_block = string
    map_public_ip_on_launch = bool
    availability_zone = string
    tags = object({
      Name = string
    })
  }))
} 
