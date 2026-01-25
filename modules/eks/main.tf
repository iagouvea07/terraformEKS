module "eks_cluster" {
    source = "./cluster"
    prefix = var.prefix
}