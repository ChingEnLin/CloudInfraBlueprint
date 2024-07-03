variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "acr-rg"
}

variable "resource_group_location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "germanywestcentral"
}

variable "container_registry_name" {
  description = "Name of the container registry"
  type        = string
  default     = "acressentialtest"
}