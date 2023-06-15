/*
This file defines the configuration for the `aks-lts-prow` cluster:
    - AKS container cluster
    - AKS container node pools
*/

variable "resource_group_name" {
  type        = string
  default     = "aks-lt-prow"
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


resource "azurerm_kubernetes_cluster" "cluster" {
  location            = var.location
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-lt-prow"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = 3
  }
  # TODO configure nodepool similar to GCP

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}


