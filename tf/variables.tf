variable "reduntancy" {
  type        = string
  description = "value of reduntancy: LRS (Local), GRS (Geo-reduntant), ZRS (Zone-renduntant), GZRS (Geo-zone-reduntant)"
  default     = "LRS" # Lowest cost
}

variable "vpn_address_space" {
  type    = string
  default = "10.80.80.0/24"
}

variable "vpn_public_key" {
  type = string
  # TODO: Handle this better
  default = "MIIC6jCCAdKgAwIBAgIIL24uWtz2Q7MwDQYJKoZIhvcNAQELBQAwEzERMA8GA1UEAxMIQ2xvdWRFUlAwHhcNMjIwODA1MTAwMzQ4WhcNMjUwODA0MTAwMzQ4WjATMREwDwYDVQQDEwhDbG91ZEVSUDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMePls0l87ScN6LFg3OqR2B5gU4ICtIArvUr04xY4qXGnmKDeiAOnKheGC08bEbnsGHKDpac7b+Xk4Un8WIfQSM2b33xMwx6iqGH4nicxuwlXk2fr30ES5IJFOswlce7AxrAERhmbOrzbCAPIfT4f0Ad0EZCGzAEgHIemL2v1NElThay9r6t+GqgORjVNvO8cYZ+WDmZUI2g01PN3M/sOY1z2p2ON4G5M38HUjNZnfcZJEApVb6ypCcvXqDlt8p6Grj203Z7ALbb9cxNyIYv2nhYJDZjOaHN6bgn4Bxf/8PZEt0UChOEtzPfrWM264VYHyLkpCVN7DiLmkKVQ4Uqz4kCAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFIDulkUWpqLAko7lT3BRBJ8vNgu4MA0GCSqGSIb3DQEBCwUAA4IBAQAyikL6W23adIMrhj6YpJYS0HMHflmO9xERjcQt7gY5KPuGJbG3TRPSMr+GwfaaJtMoL02HNZ3xPU1iEJYXtN9CnQpPKV1vz6wEx9GUjRDel71iUFayi90PBk7A3g0btWtEwrfnAvQ2HJuCEmm1H26r+seq0N7lAaA32WFWtqMJT4QsZ0+XQMqRiawkCIlyajnYiadbNowlUeCCW/5M5jyAJehftyMT7qo8bCVlN9RrjLM2gsIM9QOSxF4xFeY/x7VUn8yH/YxMkRghdDYkE+Mf6lMXa9kj45CvsTAAi6jnNQ4x3lhPdQAL40+LCYW9broiGaLjpA56P21p3Sx2dPWs"
}

variable "sqlserver_version" {
  type    = string
  default = "12.0"
}

variable "sqlserver_administrator_login" {
  type    = string
  default = "administratorsa"
}

variable "sqlserver_administrator_password" {
  type    = string
  default = "thisIsDog11"
}

variable "sqlserver_databases" {
  type    = list(any)
  default = ["cloudERP-test-db"]
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
  type    = string
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
  type        = string
  description = "How long to keep weekly backups"
  default     = "P1M"
}

variable "sqlserver_database_retention_months" {
  type        = string
  description = "How long to keep monthly backups"
  default     = "P3M"
}

variable "appserver_size" {
  type        = string
  description = "VM Size for the App Server"
  default     = "Standard_B1s"
}

variable "appserver_administrator_login" {
  type    = string
  default = "administratorsa"
}

variable "appserver_administrator_password" {
  type    = string
  default = "thisIsDog22"
}

variable "appserver_storage_type" {
  type    = string
  default = "Standard_LRS"
}

variable "appserver_disk_size_gb" {
  type    = number
  default = 127
}

variable "appserver_image_publisher" {
  type        = string
  description = "Image Publisher for the App Server"
  default     = "MicrosoftWindowsServer"
}

variable "appserver_image_offer" {
  type        = string
  description = "Image Offer for the App Server"
  default     = "WindowsServer"
}
variable "appserver_image_sku" {
  type        = string
  description = "Image SKU for the App Server"
  default     = "2022-datacenter-azure-edition"
}
variable "appserver_image_version" {
  type        = string
  description = "Image Version for the App Server"
  default     = "latest"
}

variable "tags" {
  type = map(string)
  default = {
    app         = "clouderp"
    environment = "testing"
    client      = "me"
  }
}
