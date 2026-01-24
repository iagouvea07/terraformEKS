#General
variable "region"   { type = string }
variable "profile"  { type = string }
variable "prefix"   { type = string }
  
#Vpc
variable "vpc_cidr_block" { type = string }
variable "public_subnet_cidr_block" { type = string }
variable "private_subnet_cidr_block" { type = string }