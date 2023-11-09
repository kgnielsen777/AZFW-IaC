

#New-AzResourceGroup -Name ExampleGroup -Location "Central US"

#Login-AzAccount -UseDeviceAuthentication

#Select-AzSubscription Connectivity

New-AzResourceGroupDeployment `
  -DeploymentName FWPolicyDeploy `
  -ResourceGroupName alz-westeurope-hub-networking `
  -TemplateFile .\modules\firewallrulecollectiongroups\deploy.bicep `
  -TemplateParameterFile .\modules\firewallrulecollectiongroups\deploy.parameters
