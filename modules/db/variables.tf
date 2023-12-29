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

variable "dynamo_events_table_name" {
  description = "Url shortener app dynamo table name for app events"
  type        = string
}

variable "dynamo_events_table_key_attr" {
  description = "Url shortener app dynamo events table key attribute"
  type        = string
}

variable "dynamo_events_table_index_attr" {
  description = "Index property for the events table"
  type        = string
}

variable "dynamo_events_table_range_attr" {
  description = "range key attribute for index"
  type        = string
}