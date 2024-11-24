param location string = resourceGroup().location
param name string
param sku string

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

output id string = appServicePlan.id
output name string = appServicePlan.name
