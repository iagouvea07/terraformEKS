variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}

variable "cluster_oidc" {
  type = string
}
