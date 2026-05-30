
resource "azurerm_resource_group" "urbancityrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "urbancitystorageacct" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.urbancityrg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "bronzecontainer"{
  name = "bronze"
  storage_account_name = azurerm_storage_account.urbancitystorageacct.name
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.urbancitystorageacct ]
}

resource "azurerm_storage_container" "silvercontainer" {
  name                  = "silver"
  storage_account_name = azurerm_storage_account.urbancitystorageacct.name
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.urbancitystorageacct ]
}
