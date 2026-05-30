
resource "azurerm_resource_group" "tfbackend" {
  name     = "tf-backend"
  location = "East US"
}

resource "azurerm_storage_account" "urbancitytfstorage" {
  name                     = "urbancitytfstatebackend"
  resource_group_name      = azurerm_resource_group.tfbackend.name
  location                 = azurerm_resource_group.tfbackend.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_properties {
    # enable blob versioning
    versioning_enabled = true

    # enable soft delete for blobs
    delete_retention_policy {
      days = 15
    }

    #  enable soft delete for parent container
    container_delete_retention_policy {
      days = 15
    }
  }
}

resource "azurerm_storage_container" "tfstatecontainer" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.urbancitytfstorage.name
  container_access_type = "private"
}