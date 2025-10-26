# Lambda Execution Role
resource "aws_iam_role" "lambda_execution" {
  name = "${var.project_name}-lambda-execution-role"

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

  tags = local.common_tags
}

# Lambda Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda Functions
# Post URL
resource "aws_lambda_function" "post_url" {
  filename         = "../backend/post_url.zip"
  function_name    = "${var.project_name}-post-${var.environment}"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.11"
  timeout         = 90
  memory_size     = 128

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.post_url
  ]

  tags = local.common_tags
}

# Get URL
resource "aws_lambda_function" "get_url" {
  filename         = "../backend/get_url.zip"
  function_name    = "${var.project_name}-get-${var.environment}"
  role            = aws_iam_role.lambda_execution.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.11"
  timeout         = 90
  memory_size     = 128

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.get_urls
  ]

  tags = local.common_tags
}