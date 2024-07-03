output "child_container_registry_name" {
  value = module.container_registry.container_registry_name
}

output "child_container_registry_url" {
  value = module.container_registry.container_registry_url
}

output "child_container_registry_id" {
  value = module.container_registry.container_registry_id
}

output "child_k8s_cluster_resource_group_name" {
  value = module.kubernetes_service.resource_group_name
}

output "child_k8s_cluster_name" {
  value = module.kubernetes_service.cluster_name
}

output "child_k8s_cluster_node_resource_group" {
  value = module.kubernetes_service.node_resource_group
}

# output the public ip domain name and ip as map 
output "child_public_ip_domain_name" {
  value = { for ip in module.public_ip : ip.public_ip_name => ip.public_ip_domain_name_label }
}
output "child_public_ip_address" {
  value = { for ip in module.public_ip : ip.public_ip_name => ip.public_ip_address }
}