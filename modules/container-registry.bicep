param name string
param location string = resourceGroup().location
param sku string = 'Basic'
param adminUserEnabled bool = true

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
}

output containerRegistryName string = containerRegistry.name
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryUsername string = containerRegistry.listCredentials().username
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword0 string = containerRegistry.listCredentials().passwords[0].value
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword1 string = containerRegistry.listCredentials().passwords[1].value
