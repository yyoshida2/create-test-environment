# Azure Environment Setup: Step-by-Step Guide

1. Connecting to Azure
```
Connect-AzAccount -TenantId 123456789-1234-1234-1234-123456789012 -SubscriptionId 12345678-1234-1234-1234-123456789012
```
---
2. Deploying the Environment
```
New-azresourceGroupDeployment -ResourceGroupName "rgname" -TemplateFile .\main.bicep
```