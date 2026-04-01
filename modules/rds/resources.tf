resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.global.prefix}-rds-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "${var.global.prefix}-rds-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.global.prefix}-rds-sg"
  description = "Security group for public RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.rds.port
    to_port     = var.rds.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.global.prefix}-rds-sg"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage      = 10
  db_name                = var.rds.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds.instance_class
  username               = var.rds.username
  password               = var.rds.password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  port                   = var.rds.port

  tags = {
    Name = "${var.global.prefix}-rds"
  }
}
