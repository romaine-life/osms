data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = "infra"
}

data "azurerm_key_vault" "main" {
  name                = "romaine-kv"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_user_assigned_identity" "external_secrets" {
  name                = "infra-shared-identity"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_kubernetes_cluster" "main" {
  provider            = azurerm.cluster
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

locals {
  aks_oidc_issuer_url = data.azurerm_kubernetes_cluster.main.oidc_issuer_url
}
