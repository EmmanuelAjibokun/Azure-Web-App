#!/bin/bash

RESOURCE_GROUP="cloud-decision-rg"
APP_NAME="cloud-decision-east"
PLAN="cloud-decision-plan-east"
LOCATION="westeurope"
APPRUNTIME="NODE:22-lts"
SKU="F1"

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