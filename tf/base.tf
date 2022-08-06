resource "azurerm_resource_group" "base" {
  name     = "clouderp"
  location = "France Central"

  tags = var.tags
}
