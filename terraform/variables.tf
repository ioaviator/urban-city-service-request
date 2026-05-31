
variable "resource_group_name" {
  description = "resouce group for all resources"
  default     = "urban-city-rg"
}

variable "storage_account_name" {
  description = "storage account name"
  default     = "urbancitystorageacct"
}

variable "location" {
  default = "East US"
}

variable "postgres_server" {
  type = string
  description = "postgres server name"
  default = "urban-city-requests"
}

variable "db_admin_login"{
  type = string
  description = "postgres server login username"
}

variable "db_admin_pass"{
  type = string
  description = "postgres server login password"
}