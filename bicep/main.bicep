param location string = resourceGroup().location

// ===============================================================================
// Deploy two containerized web app
param app1Name string = 'iacgranadawebsite1'
param app2Name string = 'iacgranadawebsite2'
param appServicePlanName string = 'iacGranadaAppServicePlan'

module webAppModule1 'modules/webapp.bicep' = {
  name: 'iacWebAppModule1'
  params: {
    location: location
    appName: app1Name
    appServicePlanName: appServicePlanName

  }
}

module webAppModule2 'modules/webapp.bicep' = {
  name: 'iacWebAppModule2'
  params: {
    location: location
    appName: app2Name
    appServicePlanName: appServicePlanName
  }
}

@description ('Output hostnames for the web apps')
output app1HostName string = webAppModule1.outputs.appServiceAppHostName
output app2HostName string = webAppModule2.outputs.appServiceAppHostName

// ===============================================================================
// Deploy a public IP Address for Application Gateway Frontend
var publicIPAddressName   = 'iacGranadaPublicIP'

module publicIP 'modules/publicIP.bicep' = {
  name: 'iacPublicIP'
  params: {
    location: location
    publicIPAddressName : publicIPAddressName 
  }
}

@description ('The public IPv4 address created')
output publicIPForAppGateway string = publicIP.outputs.publicIPForAppGateway

// ===============================================================================
// Deploy a virtual network for Application Gateway
var virtualNetworkName = 'iacGranadaVNet'
var virtualNetworkPrefix = '10.0.0.0/16'
var subnetPrefix = '10.0.0.0/24'
var backendSubnetPrefix = '10.0.1.0/24'

module vnet 'modules/virtualNetwork.bicep' = {
  name: 'iacVnet'
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    virtualNetworkPrefix: virtualNetworkPrefix
    subnetPrefix: subnetPrefix
    backendSubnetPrefix: backendSubnetPrefix
  }
}

// ===============================================================================
// Deploy Application Gateway
var applicationGateWayName = 'iacGranadaAppGateway'

module appGateway 'modules/applicationGateway.bicep' = {
  name: 'iacAppGateway'
  params: {
    location: location
    applicationGateWayName: applicationGateWayName
    virtualNetworkName: virtualNetworkName
    publicIPAddressName: publicIPAddressName
    app1Name: app1Name
    app2Name: app2Name
  }
}
