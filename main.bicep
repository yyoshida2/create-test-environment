// Region 指定
param location string = 'japaneast'

// NSG パラメータ
param nsgVnet1public_Name string = 'nsg-vnet1-public'
param nsgVnet1private_Name string = 'nsg-vnet1-private'

// vNet1 (Subnet) パラメータ
param vNet1_Name string = 'vnet-front'
param vNet1_addressPrefixes array = ['10.0.0.0/16']
param vNet1_Subnet1_Name string = 'subnet-public'
param vNet1_Subnet1_addressPrefix string = '10.0.0.0/24'
param vNet1_Subnet2_Name string = 'subnet-private'
param vNet1_Subnet2_addressPrefix string = '10.0.1.0/24'

// vNet2 (Subnet) パラメータ
param vNet2_Name string = 'vnet-backend'
param vNet2_addressPrefixes array = ['10.1.0.0/16']
param vNet2_Subnet1_Name string = 'subnet-private1' // vnet integration subnet
param vNet2_Subnet1_addressPrefix string = '10.1.0.0/24'
param vNet2_Subnet2_Name string = 'subnet-private2' // service bus subnet
param vNet2_Subnet2_addressPrefix string = '10.1.1.0/24'
param vNet2_Subnet3_Name string = 'subnet-private3' // sql database subnet
param vNet2_Subnet3_addressPrefix string = '10.1.3.0/24'
param vNet2_Subnet4_Name string = 'subnet-private4' // azure files subnet
param vNet2_Subnet4_addressPrefix string = '10.1.4.0/24'

// App Service パラメータ
param vNetLink_WebApp_Name string = 'vnetlink-WebApp'
param appService1_Name string = 'app-yuyotestenv1'
param appService2_Name string = 'app-yuyotestenv2'
param appService3_Name string = 'app-yuyotestenv3'
param appServicePlan_skuName string = 'S1'
param appServicePlan_skuTier string = 'Standard'
param appServicePlan_Name string = 'asp-yuyotestenv'
param privateEndpoint_webApp1_Name string = 'pe-webApp1'
param privateEndpoint_webApp2_Name string = 'pe-webApp2'
param privateEndpoint_webApp3_Name string = 'pe-webApp3'


// Application Gateway パラメータ
param appGw_AppFwPol_Name string = 'appgw-appfwpol'
param appGw_publicIp_Name string = 'appgw-publicip'
param appGateway_Name string = 'appgw-yuyotestenv'

// Azure Files パラメータ
param azureFiles_Name string = 'yuyofilestestenv'
param azureFiles_skuName string = 'Standard_LRS'
param azureFiles_kind string = 'storageV2'
param privateEndpoint_Files_Name string = 'pe-files'
param vNetLink_Files_Name string = 'vnetlink-files'

// SQL Database パラメータ
param sqlServer_Name string = 'yuyosqltestenv'
param privateEndpoint_sql_Name string = 'pe-sql'
param vNetLink_sql_Name string = 'vnetlink-sql'
param sqlAdministratorLogin string = 'yuyoadmin'
@secure()
param sqlAdministratorLoginPassword string

// Azure Service Bus パラメータ
param serviceBus_Name string = 'sb-yuyotestenv'
param serviceBus_skuName string = 'Premium'
param serviceBus_skuTier string = 'Premium'
param privateEndpoint_serviceBus_Name string = 'pe-serviceBus'
param vNetLink_serviceBus_Name string = 'vnetlink-serviceBus'


// Log Analytics パラメータ
param logAnalytics_Name string = 'la-testenv'

// Key Vault パラメータ
param keyVault_Name string = 'kv-yuyotestenv'
param keyVault_SkuName string = 'standard'

// Blob Storage パラメータ
param blobStorage_Name string = 'yuyoblobtestenv'
param blobStorage_skuName string = 'Standard_LRS'
param blobStorage_kind string = 'storageV2'

// Container Registry パラメータ
param containerRegistry_Name string = 'acryuyotestenv'
param containerRegistry_SkuName string = 'Basic'


////// リソース定義 //////
// NSG 作成 
module nsg './Modules/nsg.bicep' = {
  name: 'nsg'
  params: {
    location: location
    nsgVnet1public_Name: nsgVnet1public_Name
    nsgVnet1private_Name: nsgVnet1private_Name
  }
}

/*
resource nsgVnet1Public 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: nsgVnet1public_Name
  location: location
  properties: {
    securityRules: [
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
  }
}

resource nsgVnet1Private 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: nsgVnet1private_Name
  location: location
  properties:{
  }
}
*/

// vNet1 作成
resource vNet1 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: vNet1_Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vNet1_addressPrefixes
    }
    subnets: [
      {
        name: vNet1_Subnet1_Name
        properties: {
          addressPrefix: vNet1_Subnet1_addressPrefix
          networkSecurityGroup: {
            id: nsg.outputs.nsgVnet1PublicId
          }
        }
      }
      {
        name: vNet1_Subnet2_Name
        properties: {
          addressPrefix: vNet1_Subnet2_addressPrefix
          networkSecurityGroup: {
            id: nsg.outputs.nsgVnet1PrivateId
          }
        }
      }
    ]
  }
}

// vNet2 作成
resource vNet2 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: vNet2_Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vNet2_addressPrefixes
    }
    subnets: [
      {
        name: vNet2_Subnet1_Name
        properties: {
          addressPrefix: vNet2_Subnet1_addressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      {
        name: vNet2_Subnet2_Name
        properties: {
          addressPrefix: vNet2_Subnet2_addressPrefix
        }
      }
      {
        name: vNet2_Subnet3_Name
        properties: {
          addressPrefix: vNet2_Subnet3_addressPrefix
        }
      }
      {
        name: vNet2_Subnet4_Name
        properties: {
          addressPrefix: vNet2_Subnet4_addressPrefix
        }
      }
    ]
  }
}

// vNet Peering 作成
resource vnetPeering1to2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-03-01' = {
  name: '${vNet1_Name}/peer-${vNet2_Name}'
  properties: {
    remoteVirtualNetwork: {
      id: vNet2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    vNet1
    vNet2
  ]
}

resource vnetPeering2to1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-03-01' = {
  name: '${vNet2_Name}/peer-${vNet1_Name}'
  properties: {
    remoteVirtualNetwork: {
      id: vNet1.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
  dependsOn: [
    vNet1
    vNet2
  ]
}

// Private DNS Zones 作成
module privateDnsZones './Modules/privateDnsZones.bicep' = {
  name: 'privateDnsZones'
  params: {
    vNetLink_Files_Name: vNetLink_Files_Name
    vNetLink_sql_Name: vNetLink_sql_Name
    vNetLink_serviceBus_Name: vNetLink_serviceBus_Name
    vNetLink_WebApp_Name: vNetLink_WebApp_Name
    vNet1Id: vNet1.id
  }
}

/*
resource privateDnsZoneFiles 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.file.core.windows.net'
  location: 'global'
}

resource virtualNetworkLinksFiles 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: vNetLink_Files_Name
  location: 'global'
  parent: privateDnsZoneFiles
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vNet1.id
    }
  }
}


resource privateDnsZoneSql 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'global'
}

resource virtualNetworkLinksSql 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: vNetLink_sql_Name
  location: 'global'
  parent: privateDnsZoneSql
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vNet1.id
    }
  }
}

resource privateDnsZoneServiceBus 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.servicebus.windows.net'
  location: 'global'
}

resource virtualNetworkLinksServiceBus 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: vNetLink_serviceBus_Name
  location: 'global'
  parent: privateDnsZoneServiceBus
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vNet1.id
    }
  }
}

resource privateDnsZoneWebApp 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
}

resource virtualNetworkLinksWebApp 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: vNetLink_WebApp_Name
  location: 'global'
  parent: privateDnsZoneWebApp
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vNet1.id
    }
  }
}
*/

// App Service 作成
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlan_Name
  location: location
  sku: {
    name: appServicePlan_skuName
    tier: appServicePlan_skuTier
  }
}

resource vnetIntegrationSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet2_Subnet1_Name
  parent: vNet2
}

resource webAppSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet1_Subnet2_Name
  parent: vNet1
}

resource webApp1 'Microsoft.Web/sites@2024-04-01' = {
  name: appService1_Name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnetIntegrationSubnet.id
  }
}

resource privateEndpointWebApp1 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_webApp1_Name
  location: location
  properties: {
    subnet: {
      id: webAppSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'webApp1'
        properties: {
          privateLinkServiceId: webApp1.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}



resource webApp2 'Microsoft.Web/sites@2024-04-01' = {
  name: appService2_Name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnetIntegrationSubnet.id
  }
}

resource privateEndpointWebApp2 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_webApp2_Name
  location: location
  properties: {
    subnet: {
      id: webAppSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'webApp2'
        properties: {
          privateLinkServiceId: webApp2.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}


resource webApp3 'Microsoft.Web/sites@2024-04-01' = {
  name: appService3_Name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnetIntegrationSubnet.id
  }
}

resource privateEndpointWebApp3 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_webApp3_Name
  location: location
  properties: {
    subnet: {
      id: webAppSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'webApp3'
        properties: {
          privateLinkServiceId: webApp3.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroupWebApp1 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'webApp1'
  parent: privateEndpointWebApp1
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'webApp1'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneWebAppId
        }
      }
    ]
  }
  dependsOn: [
    privateDnsZones
  ]
}

resource privateDnsZoneGroupWebApp2 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'webApp2'
  parent: privateEndpointWebApp2
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'webApp2'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneWebAppId
        }
      }
    ]
  }
}
resource privateDnsZoneGroupWebApp3 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'webApp3'
  parent: privateEndpointWebApp3
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'webApp3'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneWebAppId
        }
      }
    ]
  }
}


// WAF ポリシー 作成
resource appGatewayAppFwPol 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-08-01' = {
  name: appGw_AppFwPol_Name
  location: location
  properties: {
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: 'Prevention'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.1'
        }
      ]
    }
  }
}

// Application Gateway 作成
resource publicIpAppGw 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: appGw_publicIp_Name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'static'
  }
}

resource appGatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet1_Subnet1_Name
  parent: vNet1
}


resource appGateway 'Microsoft.Network/applicationGateways@2024-05-01' = {
  name: appGateway_Name
  location: location
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: appGatewaySubnet.id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAppGw.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'myBackendPool'
        properties: {}
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'myHTTPSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'myListener'
        properties: {
          firewallPolicy: {
            id: appGatewayAppFwPol.id
          }
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGateway_Name, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGateway_Name, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'myRoutingRule'
        properties: {
          ruleType: 'Basic'
          priority: 10
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGateway_Name, 'myListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGateway_Name, 'myBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGateway_Name, 'myHTTPSetting')
          }
        }
      }
    ]
    enableHttp2: false
    firewallPolicy: {
      id: appGatewayAppFwPol.id
    }
  }
}



// Log Analytics 作成
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalytics_Name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}


// Key Vault 作成
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVault_Name
  location: location
  properties: {
    accessPolicies: []
    sku: {
      family: 'A'
      name: keyVault_SkuName
    }
    tenantId: subscription().tenantId
  }
}

// Blob Storage 作成
resource blobStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: blobStorage_Name
  location: location
  sku: {
    name: blobStorage_skuName
  }
  kind: blobStorage_kind
  properties: {    
  }
}

// Container Registry 作成
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistry_Name
  location: location
  sku: {
    name: containerRegistry_SkuName
  }
  properties: {
  }
}



// Azure Files 作成 (Private Endpoint)
resource azureFiles 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: azureFiles_Name
  location: location
  sku: {
    name: azureFiles_skuName
  }
  kind: azureFiles_kind
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

resource azureFilesSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet2_Subnet4_Name
  parent: vNet2
}

resource privateEndpointFiles 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_Files_Name
  location: location
  properties: {
    subnet: {
      id: azureFilesSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'file'
        properties: {
          privateLinkServiceId: azureFiles.id
          groupIds: [
            'file'
          ]
        }
      }
    ]
  }
}



resource privateDnsZoneGroupFiles 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'files'
  parent: privateEndpointFiles
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'files'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneFilesId
        }
      }
    ]
  }
}


// SQL Database 作成 (Private Endpoint)
resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServer_Name
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    publicNetworkAccess: 'Disabled'
  }
}

resource azureSqlSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet2_Subnet3_Name
  parent: vNet2
}

resource privateEndpointSql 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_sql_Name
  location: location
  properties: {
    subnet: {
      id: azureSqlSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'sql'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroupSqlServer 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'sqlServer'
  parent: privateEndpointSql
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'sqlServer'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneSqlId
        }
      }
    ]
  }
}


// Azure Service Bus 作成
resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBus_Name
  location: location
  sku: {
    name: serviceBus_skuName
    tier: serviceBus_skuTier
  }
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

resource serviceBusSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: vNet2_Subnet2_Name
  parent: vNet2
}

resource privateEndpointServiceBus 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpoint_serviceBus_Name
  location: location
  properties: {
    subnet: {
      id: serviceBusSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'serviceBus'
        properties: {
          privateLinkServiceId: serviceBus.id
          groupIds: [
            'namespace'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroupServiceBus 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  name: 'serviceBus'
  parent: privateEndpointServiceBus
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'serviceBus'
        properties: {
          privateDnsZoneId: privateDnsZones.outputs.privateDnsZoneServiceBusId
        }
      }
    ]
  }
}

