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
      id = string
      cidr = string
    }))
}

variable "public_ip" {
  type = string
}


