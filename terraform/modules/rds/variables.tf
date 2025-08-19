variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "db_username" {
  type = string
  default = "nimbus"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}
variable "eks_node_sg_id" {
  type = string
}
variable "tags" { type = map(string) }
