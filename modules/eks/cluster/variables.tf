variable "global" {
  type = object({
    region  = string
    profile = string
    prefix  = string
  })
}