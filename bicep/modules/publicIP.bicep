
param location string
param publicIPAddressName  string

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIPAddressName 
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: 'iacGranada-appgw'
    }
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

@description('The public IPv4 address created.')
output publicIPForAppGateway string = publicIPAddress.properties.ipAddress
