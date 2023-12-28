resource "aws_dynamodb_table" "short_urls" {
  name           = var.dynamo_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = var.dynamo_table_key_attr

  attribute {
    name = var.dynamo_table_key_attr
    type = "S"
  }

  attribute {
    name = var.dynamo_table_index_attr
    type = "S"
  }

  global_secondary_index {
    name            = "${var.dynamo_table_index_attr}Index"
    hash_key        = var.dynamo_table_index_attr
    range_key       = var.dynamo_table_key_attr
    projection_type = "ALL"
    read_capacity   = 500
    write_capacity  = 500
  }

  lifecycle {
    ignore_changes = [write_capacity, read_capacity]
  }

  point_in_time_recovery {
    enabled = true
  }
}

module "short_urls_table_autoscaling" {
  source     = "snowplow-devops/dynamodb-autoscaling/aws"
  version    = "0.2.1"
  table_name = aws_dynamodb_table.short_urls.name
}