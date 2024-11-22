using '../main.bicep'

param environmentType = 'nonprod'
param postgreSQLServerName = 'safebank-dbsrv-dev'
param postgreSQLDatabaseName = 'safebank-db-dev'
param postgreSQLAdminPassword = 'IE.Bank.DB.Admin.Pa$$'

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


param staticWebAppName = 'safebank-swa-dev'
param staticWebAppLocation = 'westeurope'

param registryName = 'safebankcrdev'
// Missing the dockerRegistryImageName and the dockerRegistryImageVersion params

param keyVaultName = 'safebank-kv-dev'

param keyVaultRoleAssignments = [
{
principalId: '68666a98-1b2d-4d1d-96fb-b1e8abc4e30d' // BCSAI2024-DEVOPS-PROFESSORS-SP
roleDefinitionIdOrName: 'Key Vault Secrets User'
principalType: 'ServicePrincipal'
}
{
principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
roleDefinitionIdOrName: 'Key Vault Secrets User'
principalType: 'ServicePrincipal'
}
{
principalId: '37841ca3-42b3-4aed-b215-44d6f5dcb57d' // BCSAI2024-DEVOPS-STUDENTS-B-SP
roleDefinitionIdOrName: 'Key Vault Secrets User'
principalType: 'ServicePrincipal'
}
{
principalId: '1fee20df-1b46-48ed-bc43-a7d0fe35c97f' // BCSAI2024-DEVOPS-RETAKERS-SP
roleDefinitionIdOrName: 'Key Vault Secrets User'
principalType: 'ServicePrincipal'
}
{
principalId: 'fcfa69a8-e29f-4583-964e-a16920f6e4f6' // BCSAI2024-DEVOPS-PROFESSORS
roleDefinitionIdOrName: 'Key Vault Administrator'
principalType: 'Group'
}
{
principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // BCSAI2024-DEVOPS-STUDENTS-A
roleDefinitionIdOrName: 'Key Vault Administrator'
principalType: 'Group'
}
{
principalId: 'daa3436a-d1fb-44fe-b34b-053db433cdb7' // BCSAI2024-DEVOPS-STUDENTS-B
roleDefinitionIdOrName: 'Key Vault Administrator'
principalType: 'Group'
}
{
principalId: '92f48d29-2ae1-41e3-b83e-e95e39950343' // BCSAI2024-DEVOPS-RETAKERS
roleDefinitionIdOrName: 'Key Vault Administrator'
principalType: 'Group'
}
]
