variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

variable "vpc" {
  type = object({
    vpc_cidr_block            = string
    public_subnet_cidr_block  = string
    private_subnet_cidr_block = string
  })  
}
