#!/bin/bash

RESOURCE_GROUP="cloud-decision-rg"
APP_NAME="cloud-decision-east"
PLAN="cloud-decision-plan-east"
LOCATION="westeurope"
APPRUNTIME="NODE:22-lts"
SKU="F1"

if ! az account show &>/dev/null; then
    echo "Not logged in. Run 'az login' first."
    exit 1
fi

if az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP &>/dev/null; then
    echo "App '$APP_NAME' is already deployed in '$RESOURCE_GROUP'. Run destroy.sh first if you want to redeploy."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR/app"

az webapp up \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN \
  --sku $SKU \
  --runtime $APPRUNTIME \
  --location $LOCATION \
  --os-type Linux