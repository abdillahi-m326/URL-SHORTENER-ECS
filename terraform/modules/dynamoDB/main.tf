resource "aws_dynamodb_table" "urls" {
  name         = "urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  table_class = "STANDARD"

  tags = {
    Name        = "dynamodb-table-url-shortener"
    Environment = "prod"
  }
}
