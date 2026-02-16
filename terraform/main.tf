
resource "azurerm_resource_group" "urbancityresource" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_storage_account" "storageaccountdata" {
  name                = azurerm_storage_account.urbancitystorage.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_storage_account.urbancitystorage]
}

resource "azurerm_storage_account" "urbancitystorage" {
  name                     = var.storage_account_name
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


resource "azurerm_data_factory" "urbancitydatafactory" {
  name                = "urbancityadf"
  location            = azurerm_resource_group.urbancityresource.location
  resource_group_name = azurerm_resource_group.urbancityresource.name
}


resource "azurerm_data_factory_linked_service_azure_blob_storage" "urbancityblobstoragels" {
  name              = "urban_city_blob_ls"
  data_factory_id   = azurerm_data_factory.urbancitydatafactory.id
  connection_string = data.azurerm_storage_account.storageaccountdata.primary_connection_string
}

# module "data_factory_blob_storage" {
#   source = "./data_factory_blob_storage"
#   data_factory_id = azurerm_data_factory.cdedatafactory.id
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.urbancityblobstoragels.name
# }
