resource "azurerm_key_vault" "app" {
  name                       = var.key_vault_name
  resource_group_name        = data.azurerm_resource_group.main.name
  location                   = data.azurerm_resource_group.main.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7

  tags = {
    app       = "osms"
    managedBy = "osms"
    purpose   = "app-secrets"
  }
}

resource "azurerm_role_assignment" "external_secrets_keyvault" {
  scope                = azurerm_key_vault.app.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_user_assigned_identity.external_secrets.principal_id
}

resource "azurerm_key_vault_secret" "app_grafana_oauth_client_id" {
  name         = "grafana-oauth-client-id"
  value        = azuread_application.grafana.client_id
  key_vault_id = azurerm_key_vault.app.id
}

resource "azurerm_key_vault_secret" "app_grafana_oauth_client_secret" {
  name         = "grafana-oauth-client-secret"
  value        = azuread_application_password.grafana.value
  key_vault_id = azurerm_key_vault.app.id
}

resource "azurerm_key_vault_secret" "app_grafana_admin_password" {
  name         = "grafana-admin-password"
  value        = random_password.grafana_admin.result
  key_vault_id = azurerm_key_vault.app.id

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "app_loki_identity_client_id" {
  name         = "loki-identity-client-id"
  value        = azurerm_user_assigned_identity.loki.client_id
  key_vault_id = azurerm_key_vault.app.id
}
