/*
This file defines the configuration for the `aks-lts-prow` cluster:
    - AKS container cluster
    - AKS container node pools
*/

variable "resource_group_name" {
  type        = string
  default     = "aks-lts-prow"
}

variable "location" {
  type        = string
  default     = "westus2"
  description = "Location of the resource group and the cluster."
}

variable "cluster_name" {
  type        = string
  default     = "prow"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_storage_account" "storage" {
  name                     = "aksltsprowstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  location            = var.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-lts-prow"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "prow"
    vm_size    = "Standard_D2_v2"
    node_count = 3
  }
  # TODO configure nodepool similar to GCP

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}


