@description('The location for the Logic App')
param location string

@description('The Slack Webhook URL for notifications')
@secure()
param slackWebhookUrl string

@description('The name for the Logic App')
param logicAppName string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: {
      schema: 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowDefinition.json#'
      contentVersion: '1.0.0.0'
      actions: {
        Post_to_Slack: {
          type: 'Http'
          inputs: {
            method: 'POST'
            uri: slackWebhookUrl
            headers: {
              ContentType: 'application/json'
            }
            //hello
            body: {
              text: '@{triggerBody()?[message]}'
              username: 'AzureAlertBot'
            }
          }
        }
      }
      triggers: {
        ManualTrigger: {
          type: 'Request'
          inputs: {
            schema: {
              type: 'object'
              properties: {
                message: {
                  type: 'string'
                }
              }
              required: [
                'message'
              ]
            }
          }
        }
      }
    }
  }
}

output logicAppId string = logicApp.id
