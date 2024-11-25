param location string 
param name string
param appServicePlanId string
param registryName string
@secure()
param registryServerUserName string
@secure()
param registryServerPassword string
param registryImageName string
param registryImageVersion string = 'latest'
param appSettings array = []
param appCommandLine string = ''
param workspaceId string
param instrumentationKey string
param connectionStrings string
@secure()
param adminUsername string
@secure()
param adminPassword string

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${registryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: registryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: registryServerPassword }
]

var appInsightsSettings = [
  { name: 'APPINSIGHTS_INSTRUMENTATIONKEY', value: instrumentationKey }
  { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: connectionStrings }
  { name: 'ApplicationInsightsAgent_EXTENSION_VERSION', value: '~3' }
  { name: 'XDT_MicrosoftApplicationInsights_NodeJS', value: '1' }
]

resource containerAppService 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${registryName}.azurecr.io/${registryImageName}:${registryImageVersion}'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      appCommandLine: appCommandLine
      appSettings: union(appSettings, [
        {name: 'AdminUsername', value: adminUsername}
        {name: 'AdminPassword', value: adminPassword}
      ], appInsightsSettings, dockerAppSettings)
    }
  }
}
output containerAppServiceHostName string = containerAppService.properties.defaultHostName

// Settings for the App Service
resource appServiceSettingsConfiguration 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'AppServiceSettings'
  scope: containerAppService
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
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

output containerAppServiceId string = containerAppService.identity.principalId
output containerAppServiceName string = containerAppService.properties.defaultHostName
