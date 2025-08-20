output "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  value       = aws_iam_role.lambda_exec_role.arn
}

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.lambda_repo.name
}

output "ecr_repository_url" {
  description = "ECR repository URI"
  value       = aws_ecr_repository.lambda_repo.repository_url
}