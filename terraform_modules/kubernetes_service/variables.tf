# Description: This file contains the variables that are used in the kubernetes_service module.

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-rg"
}

variable "resource_group_location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "germanywestcentral"
}

variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "log-analytics-dup"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster-dup"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aks-dup"
}