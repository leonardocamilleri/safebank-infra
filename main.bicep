@sys.description('The environment type (nonprod or prod)')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
@sys.description('The user alias to add to the deployment name')
param userAlias string = 'rorosaga'


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


// PostgreSQL Server
@sys.description('The name of the PostgreSQL Server')
param postgreSQLServerName string
param postgreSQLAdminLogin string
@secure()
param postgreSQLAdminPassword string


module postgreSQLServer 'modules/postgre-sql-server.bicep' = {
  name: 'postgreSQLServer-${userAlias}'
  params: {
    name: postgreSQLServerName
    location: location
    adminLogin: postgreSQLAdminLogin
    adminPassword: postgreSQLAdminPassword
  }
}


// PostgreSQL Database
@sys.description('The name of the PostgreSQL Database')
param postgreSQLDatabaseName string

module postgreSQLDatabase 'modules/postgre-sql-db.bicep' = {
  name: 'postgreSQLDB-${userAlias}'
  params: {
    serverName: postgreSQLServerName
    name: postgreSQLDatabaseName
  }
  dependsOn: [
    postgreSQLServer
  ]
}



// Static Web App
@sys.description('The name of the Static Web App')
param staticWebAppName string
@sys.description('The location of the Static Web App')
param staticWebAppLocation string
@sys.description('The URL of the repo with the Web App')
param feRepositoryUrl string
param staticWebAppTokenName string

module staticWebApp 'modules/static-webapp.bicep' = {
  name: 'staticWebApp-${userAlias}'
  params: {
    name: staticWebAppName
    location: staticWebAppLocation
    url: feRepositoryUrl
    keyVaultResourceId: keyVault.outputs.keyVaultId
    tokenName: staticWebAppTokenName
  }
}


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
@description('The location of the container registry')
param registryLocation string
param containerRegistryUsernameSecretName string 
param containerRegistryPassword0SecretName string 
param containerRegistryPassword1SecretName string 

module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistry-${userAlias}'
  params: {
    name: registryName
    location: registryLocation
    keyVaultResourceId: keyVault.outputs.keyVaultId
    usernameSecretName: containerRegistryUsernameSecretName
    password0SecretName: containerRegistryPassword0SecretName
    password1SecretName: containerRegistryPassword1SecretName
    
  }
}


// Key Vault
@sys.description('The name of the Key Vault')
param keyVaultName string
@sys.description('Role assignments for the Key Vault')
param keyVaultRoleAssignments array = []

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault-${userAlias}'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true 
    roleAssignments: keyVaultRoleAssignments
  }
}


// Log Analytics Workspace
@sys.description('The name of the Log Analytics Workspace')
param logAnalyticsWorkspaceName string


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


// App Insights
@sys.description('The name of the Application Insights instance')
param appInsightsName string

module appInsights 'modules/app-insights.bicep' = {
  name: 'appInsights-${userAlias}'
  params: {
    name: appInsightsName
    type: 'web' 
    location: location 
    tagsArray: {
      environment: environmentType
      owner: userAlias
    }
    workspaceResourceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId // Link to the Log Analytics Workspace
  }
}





// module appService 'modules/app-service.bicep' = {
//   name: 'appService-${userAlias}'
//   params: {
//     location: location
//     environmentType: environmentType
//     appServiceAppName: appServiceAppName
//     appServiceAPIAppName: appServiceAPIAppName
//     appServicePlanName: appServicePlanName
//     appServiceAPIDBHostDBUSER: appServiceAPIDBHostDBUSER
//     appServiceAPIDBHostFLASK_APP: appServiceAPIDBHostFLASK_APP
//     appServiceAPIDBHostFLASK_DEBUG: appServiceAPIDBHostFLASK_DEBUG
//     appServiceAPIEnvVarDBHOST: appServiceAPIEnvVarDBHOST
//     appServiceAPIEnvVarDBNAME: appServiceAPIEnvVarDBNAME
//     appServiceAPIEnvVarDBPASS: appServiceAPIEnvVarDBPASS
//     appServiceAPIEnvVarENV: appServiceAPIEnvVarENV
//   }
//   dependsOn: [
//     postgresSQLDatabase
//   ]
// }

// output appServiceAppHostName string = appService.outputs.appServiceAppHostName


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




