resource "aws_sns_topic" "sns_topic" {
  for_each = { for idx, topic in var.sns_topic : idx => topic }
  name     = each.value.name
}
