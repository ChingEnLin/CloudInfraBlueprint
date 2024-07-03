# Create a resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create a Log Analytics workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_prefix

  azure_policy_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }

  # api_server_access_profile {
  #   authorized_ip_ranges = ["172.16.201.0/24"]
  # }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  }
}

# Create a node pool
# resource "azurerm_kubernetes_cluster_node_pool" "aks_node_pool_internal" {
#   name                  = "internal"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
#   vm_size               = "Standard_DS2_v2"
#   node_count            = 1

#   enable_auto_scaling = true
#   max_count = 3
#   min_count = 1
# }