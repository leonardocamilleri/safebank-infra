@description('Name of the database alert rule')
param dbAlertName string

@description('Description of the database alert')
param dbAlertDescription string

@description('How bad the database alert is (0: Critical, 1: Error, 2: Warning, 3: Informational)')
param dbAlertSeverity int

@description('Scope of the database resource to monitor')
param dbResourceScope string

@description('Name of the Key Vault alert rule')
param kvAlertName string

@description('Description of the Key Vault alert')
param kvAlertDescription string

@description('How bad the Key Vault alert is')
param kvAlertSeverity int

@description('Scope of the Key Vault resource to monitor')
param kvResourceScope string

@description('Name of the backend response alert rule')
param beResponseAlertName string

@description('Description of the backend response alert')
param beResponseAlertDescription string

@description('How bad the backend response alert is')
param beResponseAlertSeverity int

@description('Scope of the backend resource to monitor')
param beResourceScope string

@description('Action Group Resource ID')
param actionGroupId string

// Database Alert Rule
resource dbAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: dbAlertName
  location: 'global'
  properties: {
    description: dbAlertDescription
    severity: dbAlertSeverity
    enabled: true
    scopes: [
      dbResourceScope
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'FailedConnections'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.DBforPostgreSQL/flexibleServers'
          metricName: 'connections_failed'
          operator: 'GreaterThanOrEqual'
          threshold: 1
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Database connection failures exceeded the threshold of 1. Please check immediately.'
        }
      }
    ]
  }
}

// Key Vault Alert Rule
resource kvAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: kvAlertName
  location: 'global'
  properties: {
    description: kvAlertDescription
    severity: kvAlertSeverity
    enabled: true
    scopes: [
      kvResourceScope
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'KeyVaultAvailability'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.KeyVault/vaults'
          metricName: 'Availability'
          operator: 'LessThan'
          threshold: 100
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Key Vault availability dropped below 100%. Please check immediately.'
        }
      }
    ]
  }
}

// Backend Response Time Alert Rule
resource beResponseAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: beResponseAlertName
  location: 'global'
  properties: {
    description: beResponseAlertDescription
    severity: beResponseAlertSeverity
    enabled: true
    scopes: [
      beResourceScope
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'ResponseTime'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.Web/sites'
          metricName: 'HttpResponseTime'
          operator: 'GreaterThan'
          threshold: 1
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Backend response time exceeded 1 second. Please check immediately.'
        }
      }
    ]
  }
}
