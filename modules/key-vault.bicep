@description('Name of the Key Vault')
param name string

@description('Location of the Key Vault')
param location string

@description('SKU of the Key Vault (Standard or Premium)')
param sku string

@description('Array of access policies for the Key Vault')
param accessPolicies array = []

@description('Enable Key Vault for deployment operations')
param enableVaultForDeployment bool = false

@description('Public network access setting for the Key Vault (Enabled or Disabled)')
param publicNetworkAccess string = 'Enabled'

@description('Enable soft delete for the Key Vault')
param enableSoftDelete bool = true

@description('Retention days for soft-deleted items')
param softDeleteRetentionInDays int = 90

@description('Enable purge protection for the Key Vault')
param enablePurgeProtection bool = true

@description('Network access control list (ACLs) for the Key Vault')
param networkAcls object = {
  defaultAction: 'Allow'
  bypass: 'None'
  ipRules: []
  virtualNetworkRules: []
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enableRbacAuthorization: true
    accessPolicies: accessPolicies
    tenantId: subscription().tenantId
    sku: {
      name: sku
      family: 'A'
    }
    publicNetworkAccess: publicNetworkAccess
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection
    networkAcls: networkAcls
  }
}
