# Description: This file contains the variables that are used in the vpn module.

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "vnet-rg"
}

variable "resource_group_location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "germanywestcentral"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "gateway-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "GatewaySubnet"
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "gateway-ip"
}

variable "gateway_name" {
  description = "Name of the virtual network gateway"
  type        = string
  default     = "aks-gateway"
}