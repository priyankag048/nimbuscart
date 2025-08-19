variable "project" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_zones" {
  type = object({
    zone1 = string
    zone2 = string
  })
}

variable "instance_type" {
  type = string
}

variable "instance_image" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_details" {
  description = "subnet details"
  type = list(object({
    id   = string
    cidr = string
  }))
}

variable "public_ip" {
  type = string
}

variable "sns_topic" {
  type = list(
    object({
      name = string
    })
  )
}

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

variable "tags" {
  type = map(string)
  default = {
    Project = "nimbus-cart"
  }
}


# variable "redis_node_type" {
#   type    = string
#   default = "cache.t4g.small"
# }
