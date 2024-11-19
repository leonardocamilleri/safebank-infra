@description('Name of the Application Insights resource')
param name string

@description('Type of Application Insights (e.g., web, other types)')
param type string

@description('Region where the Application Insights resource will be deployed')
param regionId string

@description('Tags to assign to the Application Insights resource')
param tagsArray object = {}

@description('Resource ID of the linked Log Analytics Workspace')
param workspaceResourceId string

resource appInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: name
  location: regionId
  kind: 'web'
  tags: tagsArray
  properties: {
    Application_Type: type
    Flow_Type: 'Redfield'
    WorkspaceResourceId: workspaceResourceId
  }
}
