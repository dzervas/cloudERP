variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

# variable "virtual_network_name" {
#   type = string
# }

# variable "cloud_address_prefix" {
#   type = string
#   description = "The address prefix for the VPN subnet - must be a subnet of the virtual network"
# }

variable "enable_backup" {
  type = bool
  default = false
}

variable "enable_logging" {
  type = bool
  default = false
}

variable "log_workspace_id" {
  type = string
  default = null
}

variable "mssql_version" {
  type    = string
  default = "12.0"
}

variable "administrator_login" {
  type    = string
  default = "administratorsa"
}

variable "administrator_password" {
  type    = string
  default = "thisIsDog11"
}

variable "databases" {
  type    = list(string)
}

variable "database_license" {
  type    = string
  default = "BasePrice"
}

variable "database_sku" {
  type    = string
  default = "Basic"
}

variable "database_storage_type" {
  type    = string
  default = "Local"
}

variable "database_collation" {
  type    = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "database_retention_days" {
  type    = number
  default = 7
}

variable "database_retention_interval" {
  type    = number
  default = 24
}

variable "database_retention_weeks" {
  type        = string
  description = "How long to keep weekly backups"
  default     = "P1M"
}

variable "database_retention_months" {
  type        = string
  description = "How long to keep monthly backups"
  default     = "P3M"
}

variable "tags" {
  type = map(string)
}
