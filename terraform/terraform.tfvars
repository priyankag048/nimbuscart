project    = "nimbus"
aws_region = "us-west-1"
aws_zones = {
  zone1 = "a"
  zone2 = "c"
}
instance_type  = "t3.micro"
instance_image = "ami-06e11c4cc68c362dd"
public_ip      = "[PUBLIC_IP]"
vpc_cidr = "10.0.0.0/16"
subnet_details = [
  {
    cidr = "10.0.1.0/24"
    id   = "public_subnet_z1"
  },
  {
    cidr = "10.0.2.0/24"
    id   = "private_subnet_z1"
  },
  {
    cidr = "10.0.3.0/24"
    id   = "private_subnet_z2"
  }
]
