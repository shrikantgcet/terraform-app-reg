

resource "azuread_application" "example" {
  display_name     = "test-azure-functions-secure4324"

  # Disable identifier_uris for the first time when you run terraform. Copy the client id from the portal after first run and then update it with in this script and then re-run terraform
  //identifier_uris  = ["api://0e871fe5-aa4e-4d7f-bd14-367b8c6bd59e"]
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access example on behalf of the signed-in user."
      admin_consent_display_name = "API Access"
      enabled                    = true
      id                         = "96183846-204b-4b43-82e1-5d2222eb4b9b"
      type                       = "User"
      user_consent_description   = "Allow the application to access example on your behalf."
      user_consent_display_name  = "API Access"
      value                      = "user_impersonation"
    }
   
  }

  feature_tags {
    enterprise = true
    gallery    = true
  }

  optional_claims {

  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

   

 resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
 
  }

}


# data "azuread_application" "example" {
#   application_id=data.azuread_application.example.application_id
#   //identifier_uris  = ["api://${data.azuread_application.example.application_id}"]
#    depends_on = [
#       azuread_application.example
#     ]
# }


resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id
  display_name="Opswat Token"
  end_date="2300-01-01T01:02:03Z"
}



# output "client_secret" {
#   value = azuread_application_password.example.value
#    # Note that you might not want to print this in out in the console all the time
# }