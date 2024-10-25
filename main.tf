# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Define variables for resource configurations
variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "aro-resource-group"
}

variable "vnet_name" {
  default = "aro-vnet"
}

variable "master_subnet_name" {
  default = "master-subnet"
}

variable "worker_subnet_name" {
  default = "worker-subnet"
}

variable "aro_cluster_name" {
  default = "aro-cluster"
}

# Create Resource Group
resource "azurerm_resource_group" "aro_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "aro_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.aro_rg.location
  resource_group_name = azurerm_resource_group.aro_rg.name
  address_space       = ["10.0.0.0/9"]
}

# Create Master Subnet
resource "azurerm_subnet" "master_subnet" {
  name                 = var.master_subnet_name
  resource_group_name  = azurerm_resource_group.aro_rg.name
  virtual_network_name = azurerm_virtual_network.aro_vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "aroDelegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Create Worker Subnet
resource "azurerm_subnet" "worker_subnet" {
  name                 = var.worker_subnet_name
  resource_group_name  = azurerm_resource_group.aro_rg.name
  virtual_network_name = azurerm_virtual_network.aro_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "aroDelegation"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Create ARO Cluster
resource "azurerm_redhat_open_shift_cluster" "aro_cluster" {
  name                = var.aro_cluster_name
  location            = azurerm_resource_group.aro_rg.location
  resource_group_name = azurerm_resource_group.aro_rg.name

  cluster_profile {
    resource_group_id       = azurerm_resource_group.aro_rg.id
    domain                  = "aro-domain"
    fips_validated_modules  = "Enabled"
    version                 = "4.8"
  }

  network_profile {
    pod_cidr      = "10.128.0.0/14"
    service_cidr  = "172.30.0.0/16"
  }

  master_profile {
    vm_size      = "Standard_D8s_v3"
    subnet_id    = azurerm_subnet.master_subnet.id
  }

  worker_profile {
    name         = "worker"
    vm_size      = "Standard_D4s_v3"
    disk_size_gb = 128
    subnet_id    = azurerm_subnet.worker_subnet.id
    count        = 3
  }

  apiserver_profile {
    visibility = "Public"
  }

  ingress_profile {
    name       = "default"
    visibility = "Public"
  }
}

# Output Cluster Credentials
output "cluster_credentials" {
  value = azurerm_redhat_open_shift_cluster.aro_cluster.console_profile.url
}
