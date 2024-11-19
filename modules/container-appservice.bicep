// param containerLocation string = resourceGroup().location
// param containerName string
// param containerAppServicePlanId string
// param dockerRegistryName string
// @secure()
// param dockerRegistryServerUserName string
// @secure()
// param dockerRegistryServerPassword string
// param dockerRegistryImageName string
// param dockerRegistryImageVersion string = 'latest'
// param appSettings array = []
// param appCommandLine string = ''
// var dockerAppSettings = [
//   { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
//   { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
//   { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
// ]
// resource containerAppService 'Microsoft.Web/sites@2022-03-01' = {
//   name: containerName
//   location: containerLocation
//   properties: {
//     serverFarmId: containerAppServicePlanId
//     httpsOnly: true
//     siteConfig: {
//       linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
//       alwaysOn: false
//       ftpsState: 'FtpsOnly'
//       appCommandLine: appCommandLine
//       appSettings: union(appSettings, dockerAppSettings)
//     }
//   }
// }
// output containerAppServiceHostName string = containerAppService.properties.defaultHostName
