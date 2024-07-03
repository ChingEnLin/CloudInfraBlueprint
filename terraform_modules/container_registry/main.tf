# Create a resource group
resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create a container registry
resource "azurerm_container_registry" "acr" {
  name                     = var.container_registry_name
  resource_group_name      = azurerm_resource_group.acr_rg.name
  location                 = azurerm_resource_group.acr_rg.location
  sku                      = "Standard"
  admin_enabled            = false
}