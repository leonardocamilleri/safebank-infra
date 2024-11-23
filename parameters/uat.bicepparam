using '../main.bicep'

// SQL Server

// SQL DB

// Satic Website (frontend)

// Container Instance (backend)

// Container Registry

// Key Vault
param keyVaultName = 'safebank-kv-uat'
param keyVaultRoleAssignments= [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]


// Log Analytics Workspace

// Application Insights

param environmentType = 'nonprod'
param postgreSQLServerName = 'safebank-dbsrv-uat'
param postgreSQLDatabaseName = 'safebank-db-uat'
param appServicePlanName = 'safebank-asp-uat'
param appServiceAPIAppName = 'safebank-be-uat'
param appServiceAppName = 'safebank-fe-uat'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'safebank-dbsrv-uat.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'safebank-db-uat'
param appServiceAPIEnvVarENV =  'uat'

param staticWebAppName = 'safebank-swa-uat'
param staticWebAppLocation = 'westeurope'

// param containerName = 'safebank-container-uat'

// param registryName = 'safebankcruat'

param logAnalyticsWorkspaceName = 'safebank-law-uat'

param appInsightsName = 'safebank-ai-uat'
