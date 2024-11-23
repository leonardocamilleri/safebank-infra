using '../main.bicep'

// SQL Server
param postgreSQLServerName = 'safebank-dbsrv-uat'
param postgreSQLAdminLogin = 'iebankdbadmin'
param postgreSQLAdminPassword = 'IE.Bank.DB.Admin.Pa$$'


// SQL DB
param postgreSQLDatabaseName = 'safebank-db-uat'

// Satic Website (frontend)
param staticWebAppName = 'safebank-swa-uat'
param staticWebAppLocation = 'westeurope'
param feRepositoryUrl = 'https://github.com/ie-safebank/safebank-fe'
param staticWebAppTokenName = 'swa-token'

// Container Instance (backend)
// param containerName = 'safebank-container-uat'

// Container Registry
param registryName = 'safebankcruat'
param registryLocation = 'westeurope'
param containerRegistryUsernameSecretName = 'acr-username'
param containerRegistryPassword0SecretName = 'acr-password0'
param containerRegistryPassword1SecretName = 'acr-password1'


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
param logAnalyticsWorkspaceName = 'safebank-law-uat'


// Application Insights
param appInsightsName = 'safebank-ai-uat'


// param environmentType = 'nonprod'
// param appServicePlanName = 'safebank-asp-uat'
// param appServiceAPIAppName = 'safebank-be-uat'
// param appServiceAppName = 'safebank-fe-uat'
// param location = 'North Europe'
// param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
// param appServiceAPIDBHostFLASK_DEBUG =  '1'
// param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
// param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
// param appServiceAPIEnvVarDBHOST =  'safebank-dbsrv-uat.postgres.database.azure.com'
// param appServiceAPIEnvVarDBNAME =  'safebank-db-uat'
// param appServiceAPIEnvVarENV =  'uat'



