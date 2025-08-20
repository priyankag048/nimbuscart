output "sns_topic" {
  value = [for topic in aws_sns_topic.sns_topic: topic]
}