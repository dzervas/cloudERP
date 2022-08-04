variable "reduntancy" {
  type        = string
  description = "value of reduntancy: LRS (Local), GRS (Geo-reduntant), ZRS (Zone-renduntant), GZRS (Geo-zone-reduntant)"
  default     = "LRS" # Lowest cost
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "vpn_address_space" {
  type = string
  default = "10.80.80.0/24"
}

variable "sqlserver_version" {
  type    = string
  default = "12.0"
}

variable "sqlserver_administrator_login" {
  type = string
  default = "administratorsa"
}

variable "sqlserver_administrator_password" {
  type = string
  default = "thisIsDog11"
}

variable "sqlserver_databases" {
  type = list
  default = [ "cloudERP-test-db" ]
}

variable "sqlserver_database_license" {
  type    = string
  default = "BasePrice"
}

variable "sqlserver_database_sku" {
  type    = string
  default = "Basic"
}

variable "sqlserver_database_storage_type" {
  type    = string
  default = "Local"
}

variable "sqlserver_database_collation" {
  type = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sqlserver_database_retention_days" {
  type    = number
  default = 7
}

variable "sqlserver_database_retention_interval" {
  type    = number
  default = 24
}

variable "sqlserver_database_retention_weeks" {
  type    = string
  description = "How long to keep weekly backups"
  default = "P1M"
}

variable "sqlserver_database_retention_months" {
  type    = string
  description = "How long to keep monthly backups"
  default = "P3M"
}

variable "appserver_size" {
  type = string
  description = "VM Size for the App Server"
  default = "Standard_B1s"
}

variable "appserver_administrator_login" {
  type = string
  default = "administratorsa"
}

variable "appserver_administrator_password" {
  type = string
  default = "thisIsDog22"
}

variable "appserver_storage_type" {
  type = string
  default = "Standard_LRS"
}

variable "appserver_disk_size_gb" {
  type = number
  default = 127
}

variable "appserver_image_publisher" {
  type = string
  description = "Image Publisher for the App Server"
  default = "MicrosoftWindowsServer"
}

variable "appserver_image_offer" {
  type = string
  description = "Image Offer for the App Server"
  default = "WindowsServer"
}
variable "appserver_image_sku" {
  type = string
  description = "Image SKU for the App Server"
  default = "2022-datacenter-azure-edition-core"
}
variable "appserver_image_version" {
  type = string
  description = "Image Version for the App Server"
  default = "latest"
}
