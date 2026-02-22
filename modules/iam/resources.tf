resource "aws_iam_role" "cluster" {
  name = "${var.global.prefix}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "nodegroup" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role" "pod" {
  name = "eks-pod"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = ["sts:AssumeRole", "sts:TagSession"]
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

//Cluster Policy
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

//Node Policy
resource "aws_iam_role_policy_attachment" "nodegroup-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-AWSLoadBalancerControllerIAMPolicy" {
  policy_arn = "arn:aws:iam::571058940344:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.nodegroup.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.nodegroup.name
}

//Pod Policy
resource "aws_iam_role_policy_attachment" "pod_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.pod.name
}

resource "aws_iam_role_policy_attachment" "pod_AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.pod.name
}