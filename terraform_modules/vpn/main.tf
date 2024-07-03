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

# Create a resource group
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = var.gateway_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  generation    = "Generation2"
  sku           = "VpnGw2"

  custom_route {
    address_prefixes = []
  }
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet.id
  }

  vpn_client_configuration {
    address_space = ["172.16.201.0/24"]

    root_certificate {
      name = "P2SRootCert"

      public_cert_data = <<EOF
MIIDAzCCAeugAwIBAgIUIVp8hUzzobTS7A8j2Y2bdt5dEr4wDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAwwGVlBOIENBMB4XDTI0MDUxNjEyMTY1OFoXDTM0MDUxNDEyMTY1OFowETEPMA0GA1UEAwwGVlBOIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwmc0NVag5A1OjmMeDJXlqTWUfpsnpWQPkj5OVeOLGY/2TbNB6LMNbfBc/MGU3dYwPz/crG5S2fvFHa4oL8V04mp6hEpcO1EwVqEVOFljaeMgC1Hz8pz41TFyoh9O4PYSzeCa52ODYW75k3MpI7EfIemP4trotLF/S3+Ekohaog4WkfFscC0mMbr9thqOyDkeWQahdYT5zPGBAdrVMDUfJbAA6fVwtolcbocxC6vAGveCX/v9PtVcgaoOOPC3QvuEVlCr20e0S53M37fJOBXPYxjjVnOBBdpqrKvgH05G4bocMTXenG9EkUhjQcKgtbc2Do9DQa//vEatRPQdMOo5ewIDAQABo1MwUTAdBgNVHQ4EFgQUC0AN3Lo9bXPoKISAewZVA5Ry/0MwHwYDVR0jBBgwFoAUC0AN3Lo9bXPoKISAewZVA5Ry/0MwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAfPaKnx5n5Z5zfNi35w0UnaIncElfjFt3I/3v31RG6jNyxeJTy5Qi82JCVCVLVn78wx1+U+5r3cyhlBOSi1VJz7LjzM3coVWQK2JU/EP6Duo/Hq3MqrN5sTchcjpCAgJ/eg1Z88LHfZqpk1nzLh7Td2tolvKXQY6YCFRsxR5GvPN+eak6pMJByGrjyLL3J1tu7YfTD2L3+uDwjCmsrLZdVB1qpNVfH2rtrjOmDB1wLsJhqbGwzWVuCqnfttoq4JbswpTjOOjhltCrbZzuwoLjYOS/JMglNNSiIZGZKKEh77uGV8Zgfptm7dPa6CrWfpMMq6yFhrIRIzfjTG/v4qlnpw==
EOF

    }
  }
}

