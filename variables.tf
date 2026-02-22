#General  
variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

#Modules
variable "vpc" {
  type = object({
    vpc_cidr_block            = string
    public_subnet_cidr_block  = string
    private_subnet_cidr_block = list(string)
  })
}

variable "eks" {
  type = object({
    version         = string
    instance_type   = string
    desired_size    = number
    max_size        = number
    min_size        = number
    max_unavailable = number
  })
}
