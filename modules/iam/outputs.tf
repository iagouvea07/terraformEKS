output "roles" {
  value = {
    cluster = {
      name = aws_iam_role.cluster.name
      arn  = aws_iam_role.cluster.arn
    }
    node = {
      name = aws_iam_role.nodegroup.name
      arn  = aws_iam_role.nodegroup.arn
    }
    pod = {
      name = aws_iam_role.pod.name
      arn  = aws_iam_role.pod.arn
    }
  }
}
