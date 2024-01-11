provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-tfmoveddemo"
  location = "uksouth"
}

resource "azurerm_key_vault" "before_move" {
  name                      = local.keyvault_name
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}

# module "avm_key_vault" {
#   source                        = "Azure/avm-res-keyvault-vault/azurerm"
#   name                          = local.keyvault_name
#   location                      = azurerm_resource_group.this.location
#   resource_group_name           = azurerm_resource_group.this.name
#   tenant_id                     = data.azurerm_client_config.current.tenant_id
#   network_acls                  = null
#   sku_name                      = "standard"
#   public_network_access_enabled = true
#   enable_telemetry              = false
#   purge_protection_enabled      = false
# }

# moved {
#   from = azurerm_key_vault.before_move
#   to   = module.avm_key_vault.azurerm_key_vault.this
# }
