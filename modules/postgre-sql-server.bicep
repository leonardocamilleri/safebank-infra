param name string
param location string = resourceGroup().location
param adminLoginName string
param adminPrincipalId string
param WorkspaceId string
// @secure()
// param adminPassword string

resource postgreSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    // administratorLogin: adminLogin
    // administratorLoginPassword: adminPassword
    createMode: 'Default'
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    version: '15'
  }
}

resource postgreSQLServerFirewallRules 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2022-12-01' = {
    parent: postgreSQLServer
    name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
}

resource postgreSQLAdmin 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2022-12-01' = {
  parent: postgreSQLServer
  name: adminPrincipalId
  properties: {
    principalName: adminLoginName
    principalType: 'admin'
    tenantId: subscription().tenantId
  }
  dependsOn: [
    postgreSQLServerFirewallRules
  ]
}


resource postgreSQLDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2020-05-01-preview' = {
  name: 'postgreSQLDiagnosticSettings'
  scope: postgreSQLServer
  properties: {
    logs: [
      {
        category: 'PostgreSQLLogs'
        enabled: true

        // Add all the logs we want to use
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    workspaceId: WorkspaceId
  }
}

output postgreSQLServerName string = postgreSQLServer.name
output postgreSQLId string = postgreSQLServer.id


