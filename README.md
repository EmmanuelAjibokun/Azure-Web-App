# Azure Web App

Deploy a Node.js app to Azure using the Azure CLI. This repo contains two deployment scripts:

- [deploy-app.sh](deploy-app.sh) — deploys the local Node.js app from the `app/` folder using `az webapp up`
- [deploy-static.sh](deploy-static.sh) — provisions a Static Web App (East US 2) and a Web App from GitHub (West Europe)

---

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- An active Azure subscription
- [Git](https://git-scm.com/) installed

---

## Quickstart

### 1. Clone the repo

```bash
git clone https://github.com/EmmanuelAjibokun/cloud-eng.git
cd azure-web-app
```

### 2. Log in to Azure

```bash
az login
```

### 3. (Optional) Set your active subscription

```bash
az account list --output table
az account set --subscription "<your-subscription-id>"
```

---

## Option A — Deploy the local Node.js app

This deploys the `app/` folder directly to an Azure Web App using `az webapp up`.

```bash
chmod +x deploy-app.sh
./deploy-app.sh
```

What it does:
- Checks that you are logged in to the Azure CLI — exits with an error if not
- Checks if `cloud-decision-east` is already deployed — exits and tells you to run `destroy.sh` first if so
- Creates the resource group `cloud-decision-rg` if it doesn't exist
- Creates or updates the App Service Plan `cloud-decision-plan-east`
- Creates or updates the Web App `cloud-decision-east`
- Zips and deploys the contents of `app/` to the web app

Once complete, your app will be live at:

```
https://cloud-decision-east.azurewebsites.net
```

> **Note:** The script deploys to `westeurope` even though the plan name says `east`. This is intentional — the free tier (F1) quota in `eastus2` was exhausted during development, so `westeurope` was used as the deployment region. If you hit the same issue in your subscription, you will need to choose a region where your free tier quota is still available.

---

## Option B — Deploy the Static Web App + GitHub-linked Web App

This script provisions two Azure resources, both sourced from a GitHub repository.

```bash
chmod +x deploy-static.sh
./deploy-static.sh
```

What it does:
- Checks that you are logged in to the Azure CLI — exits with an error if not
- Checks if `cloud-decision-west` or `cloud-decision-static-east` are already deployed — exits and tells you to run `destroy.sh` first if so
- Creates the resource group `cloud-decision-rg` in West Europe
- Creates App Service Plan `cloud-decision-plan-west` (West Europe, F1)
- Creates Web App `cloud-decision-west` linked to the GitHub repo via manual integration
- Creates Static Web App `cloud-decision-static-east` (East US 2) linked to the same GitHub repo

You will be prompted to authenticate with GitHub during the static web app creation step (`--login-with-github`).

Once complete, your resources will be available at:

```
Web App:        https://cloud-decision-west.azurewebsites.net
Static Web App: assigned URL shown in Azure portal
```

---

## Teardown

To spin down all resources and stop incurring costs, run the destroy script.

```bash
chmod +x destroy.sh
./destroy.sh
```

What it does:
- Prompts for confirmation before making any changes
- Checks that you are logged in to the Azure CLI
- Deletes the resource group `cloud-decision-rg` and everything inside it:
  - Web Apps `cloud-decision-east` and `cloud-decision-west`
  - Static Web App `cloud-decision-static-east`
  - App Service Plans `cloud-decision-plan-east` and `cloud-decision-plan-west`

Deletion is submitted with `--no-wait`, so the command returns immediately and Azure cleans up in the background. You can track progress in the portal:

```
https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups
```

---

## Project Structure

```
azure-web-app/
├── app/
│   ├── index.js          # Node.js HTTP server
│   └── package.json
├── deploy-app.sh         # Deploys local app via az webapp up
├── deploy-static.sh      # Provisions Static Web App + GitHub-linked Web App
├── destroy.sh            # Tears down all Azure resources
└── .gitignore
```
