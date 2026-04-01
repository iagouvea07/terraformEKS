variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

variable "subnets" {
  type = object({
    public_subnet_id   = list(string)
    private_subnet_id  = list(string)
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