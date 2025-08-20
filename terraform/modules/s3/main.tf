resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "invoices" {
  bucket = "${var.project}-invoices-${random_id.bucket_suffix.hex}"
  tags = {
    Name        = "${var.project}-invoices"
  }
}