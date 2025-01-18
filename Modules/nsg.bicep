param location string
param nsgVnet1public_Name string
param nsgVnet1private_Name string

// Security rules for the public NSG
var nsgVnet1PublicSecurityRules = [
  {
    name: 'AllowAppGatewayInbound'
    properties: {
      priority: 100
      direction: 'Inbound'
      access: 'Allow'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: [
        '65200-65535'
      ]
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
    }
  }
]

// Security rules for the private NSG
var nsgVnet1PrivateSecurityRules = []


// Create the NSGs 
resource nsgVnet1Public 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: nsgVnet1public_Name
  location: location
  properties: {
    securityRules: nsgVnet1PublicSecurityRules
  }
}

resource nsgVnet1Private 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: nsgVnet1private_Name
  location: location
  properties:{
    securityRules: nsgVnet1PrivateSecurityRules
  }
}

output nsgVnet1PublicId string = nsgVnet1Public.id
output nsgVnet1PrivateId string = nsgVnet1Private.id
