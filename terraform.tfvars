#General
global = {
  region  = "us-east-1"
  profile = "terraform"
  prefix  = "main"
}

#Modules
vpc = {
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
}

rds = {
  db_name        = "kubequest"
  username       = "admin"
  password       = "admin123"
  instance_class = "db.t3.micro"
  port           = 3306
}

eks = {
  cluster_name    = "main-eks-cluster"
  version         = "1.34"
  instance_type   = "t3.medium"
  desired_size    = 2
  max_size        = 2
  min_size        = 1
  max_unavailable = 1
  addons_version = {
    coredns = "v1.13.2-eksbuild.1"
    kube_proxy = "v1.34.3-eksbuild.5"
    cert_manager = "v1.19.3-eksbuild.2"
    metrics_server = "v0.8.1-eksbuild.2"
    vpc_cni = "v1.21.1-eksbuild.3"
    pod_identity = "v1.3.10-eksbuild.2"
    ebs_csi = "v1.56.0-eksbuild.1"
  }
}   