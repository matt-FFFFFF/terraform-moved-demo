data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = module.regions.regions[random_integer.region_index.result].name
}

# resource "azurerm_key_vault" "before_move" {
#   name                = module.naming.key_vault.name_unique
#   location            = azurerm_resource_group.this.location
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   sku_name            = "standard"
#   resource_group_name = azurerm_resource_group.this.name
# }

module "avm_key_vault" {
  source                   = "Azure/avm-res-keyvault-vault/azurerm"
  version                  = "~> 0.5.1"
  name                     = module.naming.key_vault.name_unique
  location                 = azurerm_resource_group.this.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  resource_group_name      = azurerm_resource_group.this.name
  enable_telemetry         = false
  sku_name                 = "standard"
  network_acls             = null
  purge_protection_enabled = false
}

moved {
  from = azurerm_key_vault.before_move
  to   = module.avm_key_vault.azurerm_key_vault.this
}
