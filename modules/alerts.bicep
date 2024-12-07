@secure()
param slackWebhookUrl string

@description('The Logic App resource ID for handling alert notifications')
param logicAppResourceId string // Dynamically passed from main.bicep

@description('The Azure location where the resources will be deployed')
param location string

resource slackActionGroup 'Microsoft.Insights/actionGroups@2021-04-01' = {
  name: 'safebank-slack-action-group'
  location: 'global'
  properties: {
    groupShortName: 'SlackAG'
    webhookReceivers: [
      {
        name: 'SlackWebhook'
        serviceUri: slackWebhookUrl
      }
    ]
  }
}

resource logicAppActionGroup 'Microsoft.Insights/actionGroups@2021-04-01' = {
  name: 'safebank-logicapp-action-group'
  location: 'global'
  properties: {
    groupShortName: 'LogicAppAG'
    logicAppReceivers: [
      {
        name: 'LogicAppTrigger'
        resourceId: logicAppResourceId
        callbackUrl: '' // Automatically populated by Azure on deployment
      }
    ]
  }
}

resource highCpuAlert 'Microsoft.Insights/metricAlerts@2021-09-01' = {
  name: 'HighCPUAlert'
  location: 'global'
  properties: {
    description: 'Triggered when CPU usage exceeds 80%'
    severity: 3
    enabled: true
    scopes: [
      resourceId('Microsoft.Compute/virtualMachines', 'safebank-vm-name')
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'GreaterThan'
          threshold: 80
        }
      ]
    }
    actions: [
      {
        actionGroupId: slackActionGroup.id
      }
      {
        actionGroupId: logicAppActionGroup.id
      }
    ]
  }
}
