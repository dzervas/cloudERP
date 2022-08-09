variable "cloud_address_prefix" {
  type = string
  description = "The address prefix for the VPN subnet - must be a subnet of the virtual network"
  default = "10.80.80.0/24"
}

variable "client_address_prefix" {
  type = string
  description = "The address prefix for the client VPN subnet - must NOT be a subnet of the virtual network"
  default = "10.80.40.0/24"
}

variable "enable_logging" {
  type = bool
  default = false
}

variable "tags" {
  type = map(string)
  default = {
    app         = "clouderp"
    environment = "testing"
    client      = "me"
  }
}
