@description('Name of the Key Vault')
param name string

@description('Location of the Key Vault')
param location string = resourceGroup().location

@description('Enable Key Vault for deployment operations')
param enableVaultForDeployment bool = true

@description('Enable RBAC authorization for the Key Vault')
param enableRbacAuthorization bool = true

@description('Enable soft delete for the Key Vault')
param enableSoftDelete bool = true

@description('Enable Key Vault for template deployment operations')
param enableVaultForTemplateDeployment bool = true

@description('SKU of the Key Vault (Standard or Premium)')
param sku string = 'standard'

@description('Role assignments for the Key Vault')
param roleAssignments array = []

@description('The name of the diagnostic setting')
param diagnosticSettingName string = 'DiagnosticSettingsName'

@description('ID of the Log Analytics Workspace')
param logAnalyticsWorkspaceId string

var builtInRoleNames = {
  Contributor: subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b24988ac-6180-42a0-ab88-20f7382dd24c'
  )
    'Key Vault Administrator': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    )
    'Key Vault Certificates Officer': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'a4417e6f-fecd-4de8-b567-7b0420556985'
    )
    'Key Vault Contributor': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'f25e0fa2-a7c8-4377-a976-54943a77a395'
    )
    'Key Vault Crypto Officer': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
    )
    'Key Vault Crypto Service Encryption User': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    )
    'Key Vault Crypto User': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '12338af0-0e69-4776-bea7-57ae8d297424'
    )
    'Key Vault Reader': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '21090545-7ca7-4776-b22c-e363652d74d2'
    )
    'Key Vault Secrets Officer': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
    )
    'Key Vault Secrets User': subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    )
    Owner: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    )
    Reader: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    )
      'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
        'Microsoft.Authorization/roleDefinitions',
        'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    )
      'User Access Administrator': subscriptionResourceId(
        'Microsoft.Authorization/roleDefinitions',
        '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
    )
  }

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enableRbacAuthorization: enableRbacAuthorization
    enableSoftDelete: enableSoftDelete
    enabledForTemplateDeployment: enableVaultForTemplateDeployment
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
  }
}

resource keyVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? roleAssignment.roleDefinitionIdOrName
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: keyVault
}
]

resource keyVaultDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
