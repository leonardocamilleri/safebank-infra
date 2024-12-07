metadata name = 'Log analytics for the application'
metadata description = 'This module creates a Log Analytics Workspace for the application'

@description('Name of the Log Analytics Workspace')
param name string

@description('Location of the Log Analytics Workspace')
param location string

@description('SKU of the Log Analytics Workspace (PerGB2018, Free, etc.)')
param sku string = 'PerGB2018'

@description('Tags to assign to the Log Analytics Workspace')
param tags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id

