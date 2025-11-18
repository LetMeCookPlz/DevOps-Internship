resource "aws_db_subnet_group" "mysql" {
  name       = "tymur-mysql-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_db_instance" "mysql" {
  identifier              = "tymur-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "webapp"
  username                = "admin"
  password                = "adminpass"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.mysql.name
  publicly_accessible     = false
  multi_az                = false
  deletion_protection     = false
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
}

resource "aws_security_group" "rds" {
  name        = "tymur-rds-sg"
  description = "Allow MySQL access from EC2 instance only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}