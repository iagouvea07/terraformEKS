resource "aws_eks_access_entry" "root" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  type          = "STANDARD"

  depends_on = [ aws_eks_cluster.cluster ]
}

resource "aws_eks_access_policy_association" "root_admin" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [ aws_eks_cluster.cluster ]
}

resource "aws_eks_access_entry" "terraform" {
    cluster_name = aws_eks_cluster.cluster.name
    principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.global.profile}"
    type = "STANDARD"
  }

  resource "aws_eks_access_policy_association" "terraform_admin" {
    cluster_name = aws_eks_cluster.cluster.name
    principal_arn = aws_eks_access_entry.terraform.principal_arn
    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

    access_scope {
      type = "cluster"
    }
}

resource "aws_eks_cluster" "cluster" {
  name = "${var.global.prefix}-eks-cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = var.roles.cluster.arn
  version  = var.eks.version

  vpc_config {
    subnet_ids = [
      for subnet in var.subnets.private_subnet_id : subnet
    ]
  }

}

resource "aws_launch_template" "nodegroup" {
  name = "${var.global.prefix}-nodegroup"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = aws_launch_template.nodegroup.name
  node_role_arn   = var.roles.node.arn
  subnet_ids      = [for subnet in var.subnets.private_subnet_id : subnet]
  instance_types  = [var.eks.instance_type]

  scaling_config {
    desired_size = var.eks.desired_size
    max_size     = var.eks.max_size
    min_size     = var.eks.min_size
  }

  update_config {
    max_unavailable = var.eks.max_unavailable
  }

}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "certmanager" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "cert-manager"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "metricsserver" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "metrics-server"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "pod-identity" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_update = "PRESERVE"
  pod_identity_association {
    role_arn = var.roles.pod.arn
    service_account = "ebs-csi-controller-sa"
  }
}

