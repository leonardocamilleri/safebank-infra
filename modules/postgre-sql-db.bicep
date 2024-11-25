param serverName string
param name string = 'safebank-db'

resource postgreSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' existing = {
  name: serverName
}

resource postgreSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: name
  parent: postgreSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

output postgreSQLDatabaseName string = postgreSQLDatabase.name
