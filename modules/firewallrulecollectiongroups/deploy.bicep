param parentName string
param location string = resourceGroup().location

//deploy policy object
resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' = {
  name: parentName
  location: location
  properties: {
    dnsSettings: {
      enableProxy: true
    }
  }

}


//rules for common

module common '1-common/commonRules.bicep' = {
  name: 'rcg-common-deployment'
  params: {
    parentName: parentName
    zone: 'EXAMPLE_common'
    SortingNumber: 1
  }
}


//copy this to create new network zones
/*
module template '999-template/templateRules.bicep' = {
  name: 'rcg-template-deployment'
  params: {
    parentName: parentName
    zone: 'Template'
  }
  dependsOn: [
    xyz
  ]
}
*/


 module hub '2-hub/hubRules.bicep' = {
  name: 'rcg-hub-deployment'
  params: {
    parentName: parentName
    zone: 'EXAMPLE_Hub'
    SortingNumber: 2
  }
  dependsOn: [
    common
  ]
}


module onPremises '3-on-premises/on-premisesRules.bicep' = {
  name: 'rcg-on-premises-deployment'
  params: {
    parentName: parentName
    zone:'EXAMPLE_on-premises'
    SortingNumber: 3
  }
  dependsOn: [
    hub
  ]
}


module ERP '4-ERP-Spoke/ERPRules.bicep' = {
  name: 'rcg-ERP-deployment'
  params: {
    parentName: parentName
    zone:'EXAMPLE_ERP'
    SortingNumber: 4
  }
  dependsOn: [
    onPremises
  ]
}


module Dataplatform '5-Dataplatform-Spoke/DataplatformRules.bicep' = {
  name: 'rcg-Dataplatform-deployment'
  params: {
    parentName: parentName
    zone:'EXAMPLE_Dataplatform'
    SortingNumber: 5
  }
  dependsOn: [
    ERP
  ]
}

module BillingApplication '6-BillingApplication-Spoke/BillingApplicationRules.bicep' = {
  name: 'rcg-BillingApplication-deployment'
  params: {
    parentName: parentName
    zone:'EXAMPLE_BillingApplication'
    SortingNumber: 6
  }
  dependsOn: [
    Dataplatform
  ]
}

/*
module spoke3 '6-Spoke3-ContainerApp3/spoke3.bicep' = {
  name: 'rcg-spoke3-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke2
  ]
}

module spoke4 '7-Spoke4-Identity/spoke4.bicep' = {
  name: 'rcg-spoke4-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke3
  ]
}

module spoke5 '8-Spoke5-AzureVirtualDesktop/spoke5.bicep' = {
  name: 'rcg-spoke5-deployment'
  params: {
    parentName: parentName
  }
  dependsOn: [
    spoke4
  ]
}
*/
