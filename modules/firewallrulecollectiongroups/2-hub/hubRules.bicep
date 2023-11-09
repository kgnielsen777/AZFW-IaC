param parentName string
param zone string
param InboundnetworkRuleCollectionName string = 'Inbound-Allow-${zone}-Network-Rules'
param InboundapplicationRuleCollectionName string = 'Inbound-Allow-${zone}-Application-Rules'
param OutboundnetworkRuleCollectionName string = 'Outbound-Allow-${zone}-Network-Rules'
param OutboundapplicationRuleCollectionName string = 'Outbound-Allow-${zone}-Application-Rules'
param SortingNumber int
param RuleCollectionGroupName string = '${SortingNumber}_${zone}'

resource parentFirewall 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: parentName
}

resource RuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: RuleCollectionGroupName
  parent: parentFirewall
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: InboundnetworkRuleCollectionName
        priority: 101
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            // Justification:
            // P2S to Spoke 1
            ruleType: 'NetworkRule'
            name: 'P2S-Spoke 1'
            description: 'Allow traffic from P2S VPN address spaces to Spoke 1'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.168.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: ['10.1.0.0/22']
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
      }
      {
        name: InboundapplicationRuleCollectionName
        priority: 102
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
        ]
      }
      {
        name: OutboundnetworkRuleCollectionName
        priority: 103
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
                              // Allow P2S to communicate with OnPremise SQL
          {
            // Justification:
            // On Premises Database
            ruleType: 'NetworkRule'
            name: 'P2S-OnPrem-SQL'
            description: 'Allow traffic from P2S VPN address spaces to a specific OnPrem IP'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.168.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: ['192.168.0.10']
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '1433'
            ]
          }
                    // Allow P2S to communicate with OnPremise WebApp
                    {
                      // Justification:
                      // On Premises WebApp
                      ruleType: 'NetworkRule'
                      name: 'P2S-OnPrem-WebApp'
                      description: 'Allow traffic from P2S VPN address spaces to a specific OnPrem IP'
                      ipProtocols: [
                        'TCP'
                      ]
                      sourceAddresses: [
                        '172.168.0.0/16'
                      ]
                      sourceIpGroups: []
                      destinationAddresses: ['192.168.0.11']
                      destinationIpGroups: []
                      destinationFqdns: []
                      destinationPorts: [
                        '433'
                      ]
                    }
        ]
      }
      {
        name: OutboundapplicationRuleCollectionName
        priority: 104
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
        ]
      }
    ]
  }
}
