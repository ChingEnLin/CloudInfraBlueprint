# Define the provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.1"
    }
  }

  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {}
}
# module "vpn" {
#   source = "./terraform_modules/vpn"
# }

module "container_registry" {
  source = "./terraform_modules/container_registry"
}

module "public_ip" {
  source = "./terraform_modules/public_ip"

  for_each = var.ip_services
  target = each.value.target
  environment = each.value.environment
}

module "kubernetes_service" {
  source = "./terraform_modules/kubernetes_service"

  depends_on = [ module.public_ip ]
}