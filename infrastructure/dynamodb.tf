resource "aws_dynamodb_table" "url_obfuscator" {
  name           = "url-obfuscator"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "N"
  }

  global_secondary_index {
    name     = "status-index"
    hash_key = "status"
    projection_type = "ALL"
  }

  tags = {
    Name = "${var.project_name}-url-obfuscator-table"
  }
}