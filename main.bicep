@sys.description('The environment type (nonprod or prod)')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
@sys.description('The user alias to add to the deployment name')
param userAlias string = 'rorosaga'
@sys.description('The PostgreSQL Server name')
@minLength(3)
@maxLength(24)
param postgreSQLServerName string = 'ie-bank-db-server-dev'
@sys.description('The PostgreSQL Database name')
@minLength(3)
@maxLength(24)
param postgreSQLDatabaseName string = 'ie-bank-db'
@sys.description('The App Service Plan name')
@minLength(3)
@maxLength(24)
param appServicePlanName string = 'ie-bank-app-sp-dev'
@sys.description('The Web App name (frontend)')
@minLength(3)
@maxLength(24)
param appServiceAppName string = 'ie-bank-dev'
@sys.description('The API App name (backend)')
@minLength(3)
@maxLength(24)
param appServiceAPIAppName string = 'ie-bank-api-dev'
@sys.description('The Azure location where the resources will be deployed')
param location string = resourceGroup().location
@sys.description('The value for the environment variable ENV')
param appServiceAPIEnvVarENV string
@sys.description('The value for the environment variable DBHOST')
param appServiceAPIEnvVarDBHOST string
@sys.description('The value for the environment variable DBNAME')
param appServiceAPIEnvVarDBNAME string
@sys.description('The value for the environment variable DBPASS')
@secure()
param appServiceAPIEnvVarDBPASS string
@sys.description('The value for the environment variable DBUSER')
param appServiceAPIDBHostDBUSER string
@sys.description('The value for the environment variable FLASK_APP')
param appServiceAPIDBHostFLASK_APP string
@sys.description('The value for the environment variable FLASK_DEBUG')
param appServiceAPIDBHostFLASK_DEBUG string

// Static Web App
@sys.description('The name of the Static Web App')
param staticWebAppName string
@sys.description('The Azure location where the Static Web App should be deployed')
param staticWebAppLocation string
@sys.description('The pricing tier for the Static Web App')
@allowed([
  'Free'
  'Standard'
])
param staticWebAppSkuName string = 'Free'
@sys.description('The SKU code for the pricing tier')
param staticWebAppSkuCode string = 'Free'
@sys.description('The URL of the repository where the source code is located')
param feRepositoryUrl string = 'https://github.com/rorosaga/safebank-fe'
@sys.description('The branch of the repository to use for deployments')
param feBranch string = 'main'
@sys.description('A secure token for accessing the repository if it is private')
@secure()
param feRepoToken string = ''
@sys.description('The folder containing the app code relative to the repository root')
param feAppLocation string = '/'
@sys.description('The folder containing the API code relative to the repository root')
param feApiLocation string = ''
@sys.description('The folder where the build artifacts are located')
param appArtifactLocation string = 'dist'

// Container App Service
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


// Container Registry
@description('The name of the container registry')
param registryName string

// Key Vault
@sys.description('The name of the Key Vault')
param keyVaultName string
@sys.description('Role assignments for the Key Vault')
param keyVaultRoleAssignments array = []

// Log Analytics Workspace
@sys.description('The name of the Log Analytics Workspace')
param logAnalyticsWorkspaceName string

// App Insights
@sys.description('The name of the Application Insights instance')
param appInsightsName string

resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: postgreSQLServerName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'iebankdbadmin'
    administratorLoginPassword: 'IE.Bank.DB.Admin.Pa$$'
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

  resource postgresSQLServerFirewallRules 'firewallRules@2022-12-01' = {
    name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

resource postgresSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: postgreSQLDatabaseName
  parent: postgresSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

module appService 'modules/app-service.bicep' = {
  name: 'appService-${userAlias}'
  params: {
    location: location
    environmentType: environmentType
    appServiceAppName: appServiceAppName
    appServiceAPIAppName: appServiceAPIAppName
    appServicePlanName: appServicePlanName
    appServiceAPIDBHostDBUSER: appServiceAPIDBHostDBUSER
    appServiceAPIDBHostFLASK_APP: appServiceAPIDBHostFLASK_APP
    appServiceAPIDBHostFLASK_DEBUG: appServiceAPIDBHostFLASK_DEBUG
    appServiceAPIEnvVarDBHOST: appServiceAPIEnvVarDBHOST
    appServiceAPIEnvVarDBNAME: appServiceAPIEnvVarDBNAME
    appServiceAPIEnvVarDBPASS: appServiceAPIEnvVarDBPASS
    appServiceAPIEnvVarENV: appServiceAPIEnvVarENV
  }
  dependsOn: [
    postgresSQLDatabase
  ]
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName

module staticWebApp 'modules/static-webapp.bicep' = {
  name: 'staticWebApp-${userAlias}'
  params: {
    staticWebAppName: staticWebAppName
    staticWebAppLocation: staticWebAppLocation
    staticWebAppSkuName: staticWebAppSkuName
    staticWebAppSkuCode: staticWebAppSkuCode
    feRepositoryUrl: feRepositoryUrl
    feBranch: feBranch
    feRepoToken: feRepoToken
    feAppLocation: feAppLocation
    feApiLocation: feApiLocation
    appArtifactLocation: appArtifactLocation
  }
}

// module containerAppService 'modules/container-appservice.bicep' = {
//   name: 'containerAppService-${userAlias}'
//   params: {
//     containerLocation: containerLocation
//     containerName: containerName
//     containerAppServicePlanId: containerAppServicePlanId
//     dockerRegistryName: dockerRegistryName
//     dockerRegistryServerUserName: dockerRegistryServerUserName
//     dockerRegistryServerPassword: dockerRegistryServerPassword
//     dockerRegistryImageName: dockerRegistryImageName
//     dockerRegistryImageVersion: dockerRegistryImageVersion
//     appSettings: appSettings
//     appCommandLine: appCommandLine
//   }
// }


module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistry-${userAlias}'
  params: {
    name: registryName
    location: location
    
  }
}


module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault-${userAlias}'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true 
    roleAssignments: keyVaultRoleAssignments
  }
}


module logAnalyticsWorkspace 'modules/log-analytics-workspace.bicep' = {
  name: 'logAnalyticsWorkspace-${userAlias}'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    sku: 'PerGB2018'
    tags: {
      environment: environmentType
      owner: userAlias
    }
  }
}


module appInsights 'modules/app-insights.bicep' = {
  name: 'appInsights-${userAlias}'
  params: {
    name: appInsightsName
    type: 'web' 
    regionId: location 
    tagsArray: {
      environment: environmentType
      owner: userAlias
    }
    workspaceResourceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId // Link to the Log Analytics Workspace
  }
}
