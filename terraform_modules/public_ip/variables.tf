variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "public-ip-rg"
}

variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "germanywestcentral"
}

variable "target" {
  description = "Name of the public IP"
  type        = string
}

variable "environment" {
  description = "Environment of the public IP"
  type        = string
}
