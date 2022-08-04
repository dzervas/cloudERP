resource "azurerm_resource_group" "base" {
  name     = "cloudERP"
  location = "France Central"

  tags = {
    app = "cloudERP"
    environment = var.environment
  }
}
