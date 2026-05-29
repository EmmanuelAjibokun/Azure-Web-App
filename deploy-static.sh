#!/bin/bash

# Configure AZURE CLI
RESOURCE_GROUP="cloud-decision-rg"
APP_NAME_EAST="cloud-decision-static-east"
APP_NAME_WEST="cloud-decision-west"
PLAN_WEST="cloud-decision-plan-west"
PLAN_EAST="cloud-decision-plan-east"
LOCATION_EAST2="eastus2"
LOCATION_WEST="westeurope"
SKU="F1"

if ! az account show &>/dev/null; then
    echo "Not logged in. Run 'az login' first."
    exit 1
fi

if az webapp show --name $APP_NAME_WEST --resource-group $RESOURCE_GROUP &>/dev/null; then
    echo "Web App '$APP_NAME_WEST' is already deployed in '$RESOURCE_GROUP'. Run destroy.sh first if you want to redeploy."
    exit 1
fi

if az staticwebapp show --name $APP_NAME_EAST --resource-group $RESOURCE_GROUP &>/dev/null; then
    echo "Static Web App '$APP_NAME_EAST' is already deployed in '$RESOURCE_GROUP'. Run destroy.sh first if you want to redeploy."
    exit 1
fi

# Create resource group
echo "Creating resource group: $RESOURCE_GROUP in $LOCATION_WEST..."
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION_WEST

# Create App Service Plans
echo "Creating App Service Plan in West Europe..."
az appservice plan create \
    --name $PLAN_WEST \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION_WEST \
    --sku $SKU

# Create App Service
az webapp create \
    --name $APP_NAME_WEST \
    --resource-group $RESOURCE_GROUP \
    --plan $PLAN_WEST \

# Deploy the app
echo "Deploying to West Europe..."
az webapp deployment source config \
    --name $APP_NAME_WEST \
    --resource-group $RESOURCE_GROUP \
    --repo-url https://github.com/EmmanuelAjibokun/cloud-decision-document.git \
    --branch main \
    --manual-integration

# Create Static WebApp
echo "Creating Static WebApp in East US 2..."
az staticwebapp create \
    --name $APP_NAME_EAST \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION_EAST2 \
    --source https://github.com/EmmanuelAjibokun/cloud-decision-document.git \
    --branch main \
    --app-location "/" \
    --output-location "/" \
    --login-with-github

echo ""
echo "Deployment complete."
echo "West Europe: https://$APP_NAME_WEST.azurewebsites.net"