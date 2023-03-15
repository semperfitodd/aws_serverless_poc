resource "aws_dynamodb_table" "customer" {
  name         = var.environment
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "CustomerId"
  range_key    = "LastName"

  attribute {
    name = "CustomerId"
    type = "N"
  }

  attribute {
    name = "LastName"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = var.tags
}