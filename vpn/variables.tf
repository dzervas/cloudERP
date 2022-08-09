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

variable "client_address_prefix" {
  type = string
  description = "The address prefix for the client VPN subnet - must NOT be a subnet of the virtual network"
  default = "10.80.40.0/24"
}

variable "enable_logging" {
  type = bool
  default = false
}

variable "log_workspace_id" {
  type = string
  default = null
}

variable "public_key" {
  type = string
  # TODO: Handle this better
  default = "MIIC6jCCAdKgAwIBAgIIL24uWtz2Q7MwDQYJKoZIhvcNAQELBQAwEzERMA8GA1UEAxMIQ2xvdWRFUlAwHhcNMjIwODA1MTAwMzQ4WhcNMjUwODA0MTAwMzQ4WjATMREwDwYDVQQDEwhDbG91ZEVSUDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMePls0l87ScN6LFg3OqR2B5gU4ICtIArvUr04xY4qXGnmKDeiAOnKheGC08bEbnsGHKDpac7b+Xk4Un8WIfQSM2b33xMwx6iqGH4nicxuwlXk2fr30ES5IJFOswlce7AxrAERhmbOrzbCAPIfT4f0Ad0EZCGzAEgHIemL2v1NElThay9r6t+GqgORjVNvO8cYZ+WDmZUI2g01PN3M/sOY1z2p2ON4G5M38HUjNZnfcZJEApVb6ypCcvXqDlt8p6Grj203Z7ALbb9cxNyIYv2nhYJDZjOaHN6bgn4Bxf/8PZEt0UChOEtzPfrWM264VYHyLkpCVN7DiLmkKVQ4Uqz4kCAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFIDulkUWpqLAko7lT3BRBJ8vNgu4MA0GCSqGSIb3DQEBCwUAA4IBAQAyikL6W23adIMrhj6YpJYS0HMHflmO9xERjcQt7gY5KPuGJbG3TRPSMr+GwfaaJtMoL02HNZ3xPU1iEJYXtN9CnQpPKV1vz6wEx9GUjRDel71iUFayi90PBk7A3g0btWtEwrfnAvQ2HJuCEmm1H26r+seq0N7lAaA32WFWtqMJT4QsZ0+XQMqRiawkCIlyajnYiadbNowlUeCCW/5M5jyAJehftyMT7qo8bCVlN9RrjLM2gsIM9QOSxF4xFeY/x7VUn8yH/YxMkRghdDYkE+Mf6lMXa9kj45CvsTAAi6jnNQ4x3lhPdQAL40+LCYW9broiGaLjpA56P21p3Sx2dPWs"
}

# variable "users" {
#   type    = list(string)
#   default = ["dzervas"]
# }

variable "tags" {
  type = map(string)
}
