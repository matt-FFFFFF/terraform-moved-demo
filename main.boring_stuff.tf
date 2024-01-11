module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4.0"
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.5.1"
}

resource "random_integer" "region_index" {
  min = 0
  max = length(module.regions.regions) - 1
}
