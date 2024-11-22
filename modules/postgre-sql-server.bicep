// param location string = resourceGroup().location
param postgreSQLServerName string
param postgreSQLDatabaseName string = 'ie-bank-db'

resource postgreSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' existing = {
  name: postgreSQLServerName
}

resource postgreSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: postgreSQLDatabaseName // parent: resourceId('Microsoft.DBforPostgreSQL/flexibleServers', postgreSQLServerName)
  parent: postgreSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

output postgreSQLDatabaseName string = postgreSQLDatabase.name
