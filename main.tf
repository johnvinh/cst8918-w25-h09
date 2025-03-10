terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "Canada Central"
  name     = "cst8918-h09"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "cst8918-h09-k8s"
  dns_prefix = "cst8918-h09-k8s"

  default_node_pool {
    name    = "cst8918h09"
    vm_size = "Standard_B2s"
    min_count = 1
    max_count = 3
    auto_scaling_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}