variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

variable "subnets" {
  type = object({
    public_subnet_id   = string
    private_subnet_id  = list(string)
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

variable "roles" {
  type = object({
    cluster = object({
      name  = string
      arn   = string
    })
    node = object({
      name  = string
      arn   = string
    })
    pod = object({
      name  = string
      arn   = string
    })
  })
}