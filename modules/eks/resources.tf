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
  name = var.eks.cluster_name

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
  version         = var.eks.version

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
  addon_version               = var.eks.addons_version.coredns
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.eks.addons_version.kube_proxy
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "cert_manager" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "cert-manager"
  addon_version               = var.eks.addons_version.cert_manager
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "metrics-server"
  addon_version               = var.eks.addons_version.metrics_server
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.eks.addons_version.vpc_cni
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "pod_identity" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.eks.addons_version.pod_identity
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.eks.addons_version.ebs_csi
  resolve_conflicts_on_update = "PRESERVE"
  pod_identity_association {
    role_arn = var.roles.pod.arn
    service_account = "ebs-csi-controller-sa"
  }
}

