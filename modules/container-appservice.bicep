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

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${registryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: registryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: registryServerPassword }
]
resource containerAppService 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${registryName}.azurecr.io/${registryImageName}:${registryImageVersion}'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      appCommandLine: appCommandLine
      appSettings: union(appSettings, dockerAppSettings)
    }
  }
}
output containerAppServiceHostName string = containerAppService.properties.defaultHostName
