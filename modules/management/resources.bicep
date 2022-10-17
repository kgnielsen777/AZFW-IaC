targetScope = 'subscription'

param location string = deployment().location
param resourceGroupName string
//param automationAccountName string
//param ddosPlanName string
param storageAccountName string
param workspaceName string
param startDate string
param endDate string
param contactEmails array
param functionAppName string
param firewallPolicyName string

module group '../shared/resource-group.bicep' = {
  name: 'resource-group-${uniqueString(resourceGroupName)}'
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

/*
module automationAccount '../shared/automation-account.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'automation-account-${uniqueString(resourceGroupName, automationAccountName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    automationAccountName: storageAccountName
    skuName: 'Basic'
  }
}
*/

/*
module ddosProtectionPlan '../shared/ddos-protection-plan.bicep' = if(false) {
  scope: resourceGroup(resourceGroupName)
  name: 'ddos-protection-plan-${uniqueString(resourceGroupName, ddosPlanName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    ddosPlanName: ddosPlanName
  }
}
*/

module storageAccount '../shared/storage-account.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'storage-account-${uniqueString(resourceGroupName, storageAccountName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    storageAccountName: storageAccountName
    skuName: 'Standard_RAGRS'
  }
}

module workspace '../shared/log-analytics-workspace.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'log-analytics-workspace-${uniqueString(resourceGroupName, workspaceName)}'
  dependsOn: [
    group
  ]
  params: {
    location: location
    workspaceName: workspaceName
  }
}

var solutions = [
  'AgentHealthAssessment'
  'AzureActivity'
  'ChangeTracking'
  'Security'
  'SecurityInsights'
  'ServiceMap'
  'SQLAdvancedThreatProtection'
  'SQLAssessment'
  'SQLVulnerabilityAssessment'
  'Updates'
  'VMInsights'
]

module solution '../shared/log-analytics-workspace-solution.bicep' = [for solution in solutions: {
  scope: resourceGroup(resourceGroupName)
  name: 'log-analytics-workspace-solution-${uniqueString(resourceGroupName, workspaceName, solution)}'
  dependsOn: [
    workspace
  ]
  params: {
    location: location
    logAnalyticsWorkspaceName: workspaceName
    solutionName: solution
  }
}]



module budget '../shared/azure-budget.bicep' = {
  name: 'budget-${uniqueString(resourceGroupName)}'
  params: {
    budgetName: 'monthly-budget'
    amount: 500
    startDate: startDate
    endDate: endDate
    contactEmails: contactEmails
  }
}


module functionapp  '../shared/function-app.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'functionapp-${uniqueString(resourceGroupName)}'
  params: {
    location: location
    appInsightsLocation: location
    functionAppName: functionAppName
    storageConnectionString: storageAccount.outputs.storageConnectionString
  }
}

module firewallpolicy '../shared/firewall-policy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'firewallpolicy-${uniqueString(resourceGroupName)}'
  params:{
    name: firewallPolicyName
    location: location
  }
}
