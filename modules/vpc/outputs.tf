output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "subnets" {
  value = {
    public_subnet_id   = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    private_subnet_id  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  }
}