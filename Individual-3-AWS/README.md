# Individual-3: AWS

### EC2 з Nginx та PHP
Знаходиться у публічній мережі. При створенні ініціалізує таблицю у RDS, що знаходиться у првиватній мережі. Пілся цього PHP конектиться до RDS та відображає вміст таблиці на веб-сторінці, яка доступна через Nginx.

<img src="../Screenshots/individual-3-aws-ec2.png" alt="Screenshot"/>

### S3 Static Website
<img src="../Screenshots/individual-3-aws-s3.png" alt="Screenshot"/>

### ECS з Nginx
Доступний через Load Balancer, який знаходиться у публічній мережі. Образ Nginx підтягує з власного ECR репозиторію. 

<img src="../Screenshots/individual-3-aws-ecs.png" alt="Screenshot"/>

### MySQL RDS
Знаходиться у приватній мережі та доступний лише для EC2. Кожний тиждень виконується автоматичний бекап. Використав MySQL замість PostgreSQL, так як краще інтегрується з PHP на EC2. 

<img src="../Screenshots/individual-3-aws-rds.png" alt="Screenshot"/>

### Lambda Healthcheck Function
Кожні 5 хвилин автоматично перевіряє, чи доступні створені вебсайти на EC2, S3 та ECS. 

<img src="../Screenshots/individual-3-aws-lambda.png" alt="Screenshot"/>

### CloudWatch Alarm (EC2 CPU > 80%)
<img src="../Screenshots/individual-3-aws-cloudwatch.png" alt="Screenshot"/>

### IAM (Новий Користувач)
<img src="../Screenshots/individual-3-aws-iam.png" alt="Screenshot"/>

### Terraform
Всі ресурси (окрім ECR) були створені через Terraform, код доступний у цьому репозиторії.