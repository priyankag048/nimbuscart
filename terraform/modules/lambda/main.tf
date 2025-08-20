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
