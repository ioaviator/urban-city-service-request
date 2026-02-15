
resource "azurerm_resource_group" "urbancityresource" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "urbancitystorage" {
  name                     = "urban-city-storage"
  resource_group_name      = azurerm_resource_group.urbancityresource.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "rawstoragecontainer" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.urbancitystorage.name
  container_access_type = "private"
}
