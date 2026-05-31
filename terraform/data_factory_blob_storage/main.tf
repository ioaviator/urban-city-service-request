
resource "azurerm_data_factory" "urbancitydatafactory" {
  name                = "urbancityadf"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_data_factory_linked_service_azure_blob_storage" "urbancityblobstoragels" {
  name              = "urban_city_blob_ls"
  data_factory_id   = azurerm_data_factory.urbancitydatafactory.id
  connection_string = var.connection_string
}



resource "azurerm_data_factory_dataset_delimited_text" "urbanlogicds" {
  name                = "urban_logic_ds"
  data_factory_id     = azurerm_data_factory.urbancitydatafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.urbancityblobstoragels.name

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "silver"
    filename  = "urban_service_requests.csv"
  }
}

resource "azurerm_data_factory_dataset_parquet" "urbanlogicds" {
  name                = "urban_logic_parquet_ds"
  data_factory_id     = azurerm_data_factory.urbancitydatafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.urbancityblobstoragels.name
  
  # Parquet compression formats: snappy, gzip, lzo, brotli, none
  compression_codec   = "snappy"

  azure_blob_storage_location {
    container = "silver"
    filename  = "urban_service_requests.parquet"
  }
}
