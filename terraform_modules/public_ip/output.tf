output "public_ip_resource_group_name" {
  value = azurerm_public_ip.aks_public_ip.resource_group_name
}

output "public_ip_name" {
  value = azurerm_public_ip.aks_public_ip.name
}

output "public_ip_address" {
  value = azurerm_public_ip.aks_public_ip.ip_address
}

output "public_ip_domain_name_label" {
  value = azurerm_public_ip.aks_public_ip.domain_name_label
}