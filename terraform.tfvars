#General
global = {
    region  = "us-east-1"
    profile = "terraform"
    prefix  = "main"
}

#Modules
vpc = {
    vpc_cidr_block            = "10.0.0.0/16"
    public_subnet_cidr_block  = "10.0.1.0/24"
    private_subnet_cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
}

eks = {
    version         = "1.33"
    instance_type   = "t3.large"
    desired_size    = 1
    max_size        = 2
    min_size        = 1
    max_unavailable = 1
}   