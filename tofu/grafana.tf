resource "azuread_application" "grafana" {
  display_name     = "Grafana"
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  owners = [data.azuread_client_config.current.object_id]

  api {
    requested_access_token_version = 2
  }

  web {
    redirect_uris = [
      "https://grafana.romaine.life/login/generic_oauth",
    ]
  }

  optional_claims {
    id_token {
      name = "email"
    }
  }
}

resource "azuread_application_password" "grafana" {
  application_id = azuread_application.grafana.id
  display_name   = "grafana-azuread"
}

resource "random_password" "grafana_admin" {
  length  = 32
  special = false
}

output "grafana_client_id" {
  value       = azuread_application.grafana.client_id
  description = "Entra application client ID for Grafana AzureAD login."
}
