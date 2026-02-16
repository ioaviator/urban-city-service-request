
resource "azurerm_resource_group" "tfbackend" {
  name     = "tf-backend"
  location = "East US"
}

resource "azurerm_storage_account" "urbancitytfstorage" {
  name                     = "urbancitytfstatebackend"
  resource_group_name      = azurerm_resource_group.tfbackend.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "tfstatecontainer" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.urbancitytfstorage.name
  container_access_type = "private"
}