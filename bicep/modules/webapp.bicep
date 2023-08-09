param location string
param appName string
param appServicePlanName string


resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }	
  sku:  {
  	name: 'B1'
    tier: 'Basic'
  }
}

resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: [ {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: '2Hx79wWUMbaIt+eRtosH8NO6CIsMDbQ9LEsg5kf4Vq+ACRAuICFN'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'myiacregistry.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: 'myiacregistry'
        }]
      linuxFxVersion: 'DOCKER|myiacregistry.azurecr.io/webserver:latest'
    }
    serverFarmId: appServicePlan.id
  }
}

output appServiceAppHostName string = webApp.properties.defaultHostName
