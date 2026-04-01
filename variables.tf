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
    public_subnet_cidr_block  = list(string)
    private_subnet_cidr_block = list(string)
  })
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

variable "eks" {
  type = object({
    cluster_name    = string
    version         = string
    instance_type   = string
    desired_size    = number
    max_size        = number
    min_size        = number
    max_unavailable = number
    addons_version = object({
      coredns         = string
      kube_proxy       = string
      cert_manager     = string
      metrics_server   = string
      vpc_cni         = string
      pod_identity    = string
      ebs_csi         = string
    })
  })
}
