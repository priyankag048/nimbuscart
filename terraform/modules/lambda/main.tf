# main.tf
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS managed policy for basic Lambda logging
resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Inline policy: read from S3 and publish to SNS
resource "aws_iam_role_policy" "lambda_inline" {
  name = "${var.project}-lambda-inline"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = var.order_response_topic_arn
      }
    ]
  })
}

resource "aws_ecr_repository" "lambda_repo" {
  name = "${var.project}-lambda"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project}-lambda"
  }
}

resource "aws_lambda_function" "order_finalized_notification" {
  package_type  = "Image"
  function_name = "nimbus-order-finalized-notification"
  image_uri     = "115785432369.dkr.ecr.us-west-1.amazonaws.com/nimbus-lambda@sha256:2e2ee26646312e811f0c92225d4c6a602c4e374f7b5d6193590b747f5db13d57"
  role          = aws_iam_role.lambda_exec_role.arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = var.order_finalized_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.order_finalized_notification.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "sns-invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.order_finalized_notification.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.order_finalized_topic_arn
}
