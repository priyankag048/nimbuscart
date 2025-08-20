output vpc_id {
    value = module.vpc.vpc_id
}

output "gateway_id" {
  value = module.vpc.gateway_id
}

output "jumpbox_ip" {
    value = module.ec2-jumpbox.jumpbox_public_ip
}

output public_subnet_id {
    value = local.public_subnet_id
}

output "private_subnet_ids" {
  value = local.private_subnet_ids
}

# output "db_endpoint" {
#   value = module.rds.db_endpoint
# }

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "topic_list" {
  value = local.topic_list
}

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = module.lambda.ecr_repository_name
}

output "ecr_repository_url" {
  description = "ECR repository URI"
  value       = module.lambda.ecr_repository_url
}

output "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  value       = module.lambda.lambda_role_arn
}