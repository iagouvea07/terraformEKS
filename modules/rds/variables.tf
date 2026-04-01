variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "rds" {
  type = object({
    db_name        = string
    username       = string
    password       = string
    instance_class = string
    port           = number
  })
}
