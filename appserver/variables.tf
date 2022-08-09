variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "cloud_address_prefix" {
  type = string
  description = "The address prefix for the VPN subnet - must be a subnet of the virtual network"
}

variable "private_ip" {
  type = string
  default = "Dynamic"
  # TODO: Validate that this is a valid IP address or "Dynamic"
  # validation {
  #   condition = private_ip == "Dynamic" || cidrhost(var.cloud_address_prefix, 0) ==
  #   error_message = "Private IP address must be set"
  # }
}

variable "enable_backup" {
  type = bool
  default = false
}

variable "log_workspace_id" {
  type = string
  default = null
}

variable "size" {
  type        = string
  description = "VM Size for the App Server"
  default     = "Standard_B1s"
}

variable "administrator_login" {
  type    = string
  default = "administratorsa"
}

variable "administrator_password" {
  type    = string
  default = "thisIsDog22"
}

variable "storage_type" {
  type    = string
  default = "Standard_LRS"
}

variable "disk_size_gb" {
  type    = number
  default = 127
}

variable "image_publisher" {
  type        = string
  description = "Image Publisher for the App Server"
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  type        = string
  description = "Image Offer for the App Server"
  default     = "WindowsServer"
}
variable "image_sku" {
  type        = string
  description = "Image SKU for the App Server"
  default     = "2022-datacenter-azure-edition"
}
variable "image_version" {
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
