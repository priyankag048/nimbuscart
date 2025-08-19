variable "sns_topic" {
  type = list(
    object({
      name = string
    })
  )
}
