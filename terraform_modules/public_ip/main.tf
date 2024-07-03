# Create public IP
resource "azurerm_public_ip" "aks_public_ip" {
  name                = "AKSPublicIP${var.target}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "vpatient-dup-${var.target}-${var.environment}"

  tags = {
    environment = var.environment
  }
}