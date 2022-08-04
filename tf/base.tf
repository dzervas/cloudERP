resource "azurerm_resource_group" "base" {
  name     = "cloudERP"
  location = "France Central"

  tags = var.tags
}
