output "nginx_url" {
  description = "URL to access the Nginx server"
  value       = "http://${aws_instance.nginx.public_ip}"
}

output "s3_website_url" {
  description = "URL to access the S3 static website"
  value       = "http://${aws_s3_bucket.static_website.bucket}.s3-website.${var.region}.amazonaws.com"
}

output "ecs_service_url" {
  description = "URL to access the ECS service"
  value       = "http://${aws_lb.ecs.dns_name}"
}

output "rds_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.address
}