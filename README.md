# Terraform template for EKS Cluster ⚙️

This project has the goal for simplify and accelerate the EKS Cluster creation in the AWS account.

The focus is provision an basic network structure with kubernetes cluster with minimal user informations as a possible.

The following resources that will be created are:

### Terraform
- 1 VPC
- 1 Public Subnet and 2 Private Subnets
- 1 Internet Gateway
- 1 NAT Gateway
- 1 Public Route Table and 1 Private Route Table
- 1 IAM Policy
- 1 EKS Cluster
- 1 EKS Nodegroup
- 5 Essentials Addons (coredns, kube-proxy, cert-manager, metrics-server, vpc-cni, ebs-csi)

### Helm Charts
- 1 Load Balancer Controller

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
- addons_version

Each scope is formated as an object, where is declared in **terraform.tfvars** file.

**HINT: To check all the addons version, you should use the following command**

```bash
aws eks describe-addon-versions --kubernetes-version 1.34  --query 'addons[].{Name:addonName,Versions:addonVersions[0].addonVersion}' --output table
```

### **Create resources with Terraform Template**

After that, just execute the following command to create all the resources:

```bash
terraform apply
```

### **Create Load Balancer Controller with Helm Chart**

The next step is the Load Balancer Controller creation.

To do this, you should configure the following parameters in **helm/values.yaml**:

```yaml
deployment:
  clusterName: "cluster-name"
  vpcId: "vpc-id"

serviceAccount:
  accountId: "aws-account-id"
```

Finally, execute the following command to create your Load Balancer Controller:

```bash
helm install aws-load-balancer-controller ./helm -n kube-system
```