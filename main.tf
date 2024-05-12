#test
data "azurerm_client_config" "current" {
}
data "azurerm_resource_group" "rg" {
  name = "rg-4-fhir"
}
resource "azurerm_healthcare_service" "healthcare_svc" {
  name                = "fhir-health-az"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "southcentralus"
  kind                = "fhir-R4"
  cosmosdb_throughput = "2000"

  access_policy_object_ids = [data.azurerm_client_config.current.object_id]

  authentication_configuration {
    authority           = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
    audience            = "https://fhir-health-az.azurehealthcareapis.com/"
    smart_proxy_enabled = "true"
  }

  cors_configuration {
    allowed_origins    = ["http://www.example.com", "http://www.example2.com"]
    allowed_headers    = ["*"]
    allowed_methods    = ["GET", "PUT"]
    max_age_in_seconds = "500"
    allow_credentials  = "true"
  }
}
