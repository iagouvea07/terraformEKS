output "subnets" {
  value = {
    public_subnet_id   = aws_subnet.public_subnet.id
    private_subnet_id  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  }
}