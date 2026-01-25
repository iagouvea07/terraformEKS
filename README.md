# Terraform template for EKS Cluster ⚙️

This project has the goal for simplify and accelerate the EKS Cluster creation in the AWS account.

The focus is provision an basic network structure with kubernetes cluster with minimal user informations as a possible.

The following resources that will be created are:

- 1 VPC
- 1 Public Subnet and 2 Private Subnets
- 1 Internet Gateway
- 1 NAT Gateway
- 1 Public Route Table and 1 Private Route Table
- 1 EKS Cluster
- 1 EKS Nodegroup
- 6 Essentials Addons (coredns, kube-proxy, cert-manager, metrics-server, vpc-cni, aws-ebs-csi-driver)

## Required variables

The following variable are requires to execute your terraform infraestructure:

### Global
- region
- profile
- prefix

### Vpc
- vpc_cidr_block
- public_subnet_cidr_block
- private_subnet_cidr_block

### Eks
- version
- instance_type
- desired_size
- max_size
- min_size
- max_unavailable

Each scope is formated as an object, where is declared in **terraform.tfvars** file.