data "azuread_client_config" "current" {}

resource "azuread_group" "ad" {
  display_name = "VPN Members"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description = "CloudERP VPN Members"
  mail_enabled = false
  prevent_duplicate_names = true
  visibility = "Private"
}
