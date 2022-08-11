variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "enable_backup" {
  type = bool
  default = false
}

variable "log_workspace_id" {
  type = string
  default = ""
}

variable "quota" {
  type = number
  default = 100
}
