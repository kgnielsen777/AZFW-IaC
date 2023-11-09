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
