output "sns_topic_arn" {
  value = [for topic in aws_sns_topic.sns_topic:topic]
}