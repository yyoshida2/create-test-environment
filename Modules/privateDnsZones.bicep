param vNetLink_Files_Name string
param vNetLink_sql_Name string
param vNetLink_serviceBus_Name string
param vNetLink_WebApp_Name string
param vNet1Id string

// Create the private DNS zones (Azure Files)
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
      id: vNet1Id
    }
  }
}

// Create the private DNS zones (SQL Server)
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
      id: vNet1Id
    }
  }
}

// Create the private DNS zones (Service Bus)
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
      id: vNet1Id
    }
  }
}

// Create the private DNS zones (Web App)
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
      id: vNet1Id
    }
  }
}

output privateDnsZoneFilesId string = privateDnsZoneFiles.id
output privateDnsZoneSqlId string = privateDnsZoneSql.id
output privateDnsZoneServiceBusId string = privateDnsZoneServiceBus.id
output privateDnsZoneWebAppId string = privateDnsZoneWebApp.id
