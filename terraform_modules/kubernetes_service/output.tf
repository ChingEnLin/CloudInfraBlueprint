output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}