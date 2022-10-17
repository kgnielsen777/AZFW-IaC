# upgrade bicep
az bicep upgrade
az upgrade

# get env parameters
$envParams = Get-Content .\scripts\envparams.json | ConvertFrom-Json

# login and set subscription
az login
az account set --subscription $envParams.subscriptionid

# allow az cli extensions
az config set extension.use_dynamic_install=yes_without_prompt

# global variables
$location = "westeurope"

# deploy management resource group
az deployment sub create --location $location `
    --template-file .\modules\management\resources.bicep `
    --parameters .\modules\management\resources.parameters.json
