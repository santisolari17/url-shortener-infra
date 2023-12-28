variable "dynamo_table_name" {
  description = "Url shortener app dynamo table name"
  type        = string
}

variable "dynamo_table_key_attr" {
  description = "Url shortener app dynamo table key attribute"
  type        = string
}

variable "dynamo_table_index_attr" {
  description = "Index property for the table"
  type        = string
}