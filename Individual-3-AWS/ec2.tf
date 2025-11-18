resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.nginx.id]
  key_name               = aws_key_pair.nginx.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/init.sh", {
    db_host     = aws_db_instance.mysql.address
    db_name     = "webapp"
    db_username = "admin"
    db_password = "adminpass"
  })

  tags = {
    Name = "tymur-ec2"
  }

  depends_on = [aws_db_instance.mysql]
}

resource "aws_security_group" "nginx" {
  name        = "tymur-nginx-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "nginx-sg"
  }
}

resource "aws_key_pair" "nginx" {
  key_name   = "ec2-key"
  public_key = file("~/.ssh/nginx-key.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "tymur-ec2-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when EC2 CPU usage exceeds 80%"
  dimensions = {
    InstanceId = aws_instance.nginx.id
  }
  treat_missing_data = "notBreaching"
}