resource "aws_iam_role" "lambda_role" {
  name = "tymur-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_sns" {
  name = "tymur-lambda-sns"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "health_check" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "tymur-lambda-health-check"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  timeout         = 30

  environment {
    variables = {
      EC2_URL      = "http://${aws_instance.nginx.public_ip}"
      S3_URL       = "http://${aws_s3_bucket.static_website.bucket}.s3-website.${var.region}.amazonaws.com"
      ECS_URL      = "http://${aws_lb.ecs.dns_name}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "health_check_schedule" {
  name                = "tymur-health-check-schedule"
  description         = "Schedule for website health checks"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "health_check_lambda" {
  rule      = aws_cloudwatch_event_rule.health_check_schedule.name
  target_id = "health-check-lambda"
  arn       = aws_lambda_function.health_check.arn
}

resource "aws_lambda_permission" "cloudwatch_health_check" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_check_schedule.arn
}