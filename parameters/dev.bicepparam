using '../main.bicep'

// SQL Server
param postgreSQLServerName = 'safebank-dbsrv-dev'
param postgreSQLAdminLogin = 'iebankdbadmin'
param postgreSQLAdminPassword = 'IE.Bank.DB.Admin.Pa$$'


// SQL DB
param postgreSQLDatabaseName = 'safebank-db-dev'

// Satic Website (frontend)
param staticWebAppName = 'safebank-swa-dev'
param staticWebAppLocation = 'westeurope'
param feRepositoryUrl = 'https://github.com/ie-safebank/safebank-fe'
param staticWebAppTokenName = 'swa-token'

// Container Instance (backend)
// param containerName = 'safebank-container-dev'

// Container Registry
param registryName = 'safebankcrdev'
param registryLocation = 'westeurope'
param containerRegistryUsernameSecretName = 'acr-username'
param containerRegistryPassword0SecretName = 'acr-password0'
param containerRegistryPassword1SecretName = 'acr-password1'


// Key Vault
param keyVaultName = 'safebank-kv-dev'
param keyVaultRoleAssignments= [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]


// Log Analytics Workspace
param logAnalyticsWorkspaceName = 'safebank-law-dev'


// Application Insights
param appInsightsName = 'safebank-ai-dev'


param environmentType = 'nonprod'
param appServicePlanName = 'safebank-asp-dev'
param appServiceAPIAppName = 'safebank-be-dev'
param appServiceAppName = 'safebank-fe-dev'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'safebank-dbsrv-dev.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'safebank-db-dev'
param appServiceAPIEnvVarENV =  'dev'



