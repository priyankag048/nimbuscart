variable "cluster" {
  type = object({
    name                = string
    version             = string
    node_instance_types = list(string)
    desired_size        = number
    max_size            = number
    min_size            = number
  })
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "tags" { type = map(string) }
