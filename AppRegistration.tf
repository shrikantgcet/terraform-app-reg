

resource "azuread_application" "example" {
  display_name     = "test-azure-functions-secure4324"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
}

