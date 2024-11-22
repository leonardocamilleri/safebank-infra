param registryName string
param registryLocation string = 'westeurope'
@allowed([
  'enabled'
  'disabled'
])
param zoneRedundancy string = 'disabled'
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param registrySku string = 'Basic'
param tags object = {}
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'
param keyVaultResourceId string
param keyVaultSecreNameAdminUsername string
#disable-next-line secure-secrets-in-params
param keyVaultSecreNameAdminPassword0 string
#disable-next-line secure-secrets-in-params
param keyVaultSecreNameAdminPassword1 string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: registryName
  location: registryLocation
  sku: {
    name: registrySku
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
  }
  tags: tags
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
name: last(split(!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault', '/'))
//scope: resourceGroup(split(!empty(keyVaultResourceId) ? keyVaultResourceId : '//', '/')[2], split(!empty(keyVaultResourceId) ? keyVaultResourceId : '////', '/')[4])
}

// create a secret to store the container registry admin username 
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminUsername)) {
  name: !empty(keyVaultSecreNameAdminUsername) ? keyVaultSecreNameAdminUsername: 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
  }
}

// create a secret to store the container registry admin password 0
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminPassword0)) {
  name: !empty(keyVaultSecreNameAdminPassword0) ? keyVaultSecreNameAdminPassword0 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
  }
}

// create a secret to store the container registry admin password 1
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminPassword1)) {
  name: !empty(keyVaultSecreNameAdminPassword1) ? keyVaultSecreNameAdminPassword1 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
  }
}

output containerRegistryName string = containerRegistry.name
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryUsername string = containerRegistry.listCredentials().username
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword0 string = containerRegistry.listCredentials().passwords[0].value
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword1 string = containerRegistry.listCredentials().passwords[1].value
