
resource "azurerm_resource_group" "urbancityrg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_storage_account" "storageaccountdata" {
  name                = azurerm_storage_account.urbancitystorageacct.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_storage_account.urbancitystorageacct]
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


// postgresql server
resource "azurerm_postgresql_flexible_server" "urbancityserver" {
  name                          = var.postgres_server
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  public_network_access_enabled = true
  administrator_login           = var.db_admin_login
  administrator_password        = var.db_admin_pass
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name    = "GP_Standard_D4s_v3"
  create_mode = "Default"

  authentication {
    password_auth_enabled = true
  }

  depends_on = [ azurerm_resource_group.urbancityrg ]

}

resource "azurerm_postgresql_flexible_server_database" "urbancitydb" {
  name      = "urban_city_db"
  server_id = azurerm_postgresql_flexible_server.urbancityserver.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}



module "data_factory_blob_storage" {
  source = "./data_factory_blob_storage"
  location            = azurerm_resource_group.urbancityrg.location
  resource_group_name = azurerm_resource_group.urbancityrg.name
  connection_string = data.azurerm_storage_account.storageaccountdata.primary_connection_string
}
