output "cluster_name" { value = aws_eks_cluster.this.name }
output "cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
output "node_sg_id" { value = aws_security_group.nodes.id }
output "oidc_provider_arn" { value = aws_iam_openid_connect_provider.oidc.arn }
