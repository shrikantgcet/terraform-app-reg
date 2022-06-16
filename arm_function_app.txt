

resource "azurerm_storage_account" "example" {
    name                     = "testazurefunctions32112"
    resource_group_name      = data.azurerm_resource_group.fun_app.name
    location                 = data.azurerm_resource_group.fun_app.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
  
  resource "azurerm_app_service_plan" "example" {
    name                = "test-azure-functions-secure32112-service-plan"
    location            = data.azurerm_resource_group.fun_app.location
    resource_group_name = data.azurerm_resource_group.fun_app.name
    kind                = "FunctionApp"
    
    sku {
      tier = "Dynamic"
      size = "Y1"
    }
  }
  
  resource "azurerm_function_app" "example" {
    name                       = "test-azure-functions-secure32112"
    location                   = data.azurerm_resource_group.fun_app.location
    resource_group_name        = data.azurerm_resource_group.fun_app.name
    app_service_plan_id        = azurerm_app_service_plan.example.id
    storage_account_name       = azurerm_storage_account.example.name
    storage_account_access_key = azurerm_storage_account.example.primary_access_key
    version                    = "~3"
    identity {
        type = "SystemAssigned"
    }
    depends_on = [
      azuread_application.example
    ]
    app_settings ={
    Token_Value = azuread_application_password.example.value
  }
    
  }



  resource "azurerm_resource_group_template_deployment" "arm" {
  name      = "authsettingsV2-${azurerm_function_app.example.name}"
  resource_group_name        = data.azurerm_resource_group.fun_app.name
  depends_on = [
      azurerm_function_app.example
  ]
  deployment_mode = "Incremental" 
  parameters_content = jsonencode({
    "appName" = {
      value = "test-azure-functions-secure32112"
    }
  })
  
  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
       "appName": {
            "type": "string",
            "metadata": {
                "description": "Name of the function app"
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Web/sites/config",
            "apiVersion": "2021-03-01",
            "name": "[concat(parameters('appName'), '/authsettingsV2')]",
            "properties": {
                "platform": {
                    "enabled": true
                },
                "globalValidation": {
                    "requireAuthentication": true,
                    "unauthenticatedClientAction": "Return401"
                },
                "identityProviders": {
                    "azureActiveDirectory": {
                        "enabled": true,
                        "registration": {
                            "openIdIssuer": "[concat('https://sts.windows.net/', '1b8b93e0-fc23-441e-ab35-a908300672d3', '/v2.0')]",
                            "clientId": "67cc01eb-5edc-4236-bd37-0a1a51e94e6a",
                            "clientSecretSettingName": "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
                        },
                        "validation": {
                            "allowedAudiences": [
                                "api://67cc01eb-5edc-4236-bd37-0a1a51e94e6a"
                            ],
                            "defaultAuthorizationPolicy": {
                            }
                        },
                        "isAutoProvisioned": false
                    },
                    "login": {
                        "tokenStore": {
                            "enabled": true
                        }
                    },
                    "httpSettings": {
                        "requireHttps": true
                    }
                }
            }
        }
    ]
}
  
   TEMPLATE




}
