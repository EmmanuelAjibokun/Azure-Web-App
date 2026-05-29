#!/bin/bash

RESOURCE_GROUP="cloud-decision-rg"

read -rp "This will delete '$RESOURCE_GROUP' and all resources inside it. Type 'yes' to confirm: " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
    echo "Aborted. No resources were deleted."
    exit 0
fi

if ! az account show &>/dev/null; then
    echo "Not logged in. Run 'az login' first."
    exit 1
fi

if ! az group show --name "$RESOURCE_GROUP" &>/dev/null; then
    echo "Resource group '$RESOURCE_GROUP' not found. Nothing to destroy."
    exit 0
fi

echo "Deleting resource group '$RESOURCE_GROUP'..."
az group delete \
    --name $RESOURCE_GROUP \
    --yes \
    --no-wait

echo "Done. Azure is cleaning up resources in the background."
