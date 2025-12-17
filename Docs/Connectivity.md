# Connectivity Guide

This document covers how to connect your PowerShell environment to the various modules and services required for system administration tasks.

Each section includes common connection methods, prerequisites, and troubleshooting notes.

---

## Prerequisites

Before connecting to any service, ensure that you have:

- PowerShell 7.x or later (recommended)
- Administrative privileges
- Necessary modules installed (examples below)
- Network access and credentials with sufficient permissions

You can install required modules using:

```
# Example module installations
Install-Module ActiveDirectory
Install-Module ExchangeOnlineManagement
Install-Module MicrosoftTeams
Install-Module AzureAD
Install-Module Az
Install-Module SharePointPnPPowerShellOnline
```

---

## Active Directory (On-Prem)

The **ActiveDirectory** module is typically available on domain-joined systems or via RSAT tools.

```
# Import AD module
Import-Module ActiveDirectory

# Verify connectivity
Get-ADDomainController -Discover
Get-ADUser <samAccountName>
```

**Note:** No manual connection is needed for on-prem AD once you're authenticated to the domain.

---

## Azure AD

Azure Active Directory can be managed using either the **AzureAD** or **Microsoft Graph** module.

```
# Connect using AzureAD module
Connect-AzureAD
```

Or, with **Microsoft Graph** (recommended for modern automation):

```
# Connect using Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"
Select-MgProfile -Name beta
```

---

## Microsoft 365 Exchange Online

The **ExchangeOnlineManagement** module allows management of mailboxes, transport rules, and other Exchange components.

```
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName <admin@domain.com>
```

---

## Microsoft Teams

The **MicrosoftTeams** module manages Teams, channels, and policies.

```
Import-Module MicrosoftTeams
Connect-MicrosoftTeams
```

To disconnect:

```
Disconnect-MicrosoftTeams
```

---

## SharePoint Online (PnP PowerShell)

Use the **PnP.PowerShell** module for efficient SharePoint site administration.

```
Connect-PnPOnline -Url https://<tenant>.sharepoint.com/sites/<SiteName> -Interactive
```

To disconnect:

```
Disconnect-PnPOnline
```

---

## Azure (Az Module)

The **Az** module is the modern unified management module for Azure resources.

```
# Log in interactively
Connect-AzAccount

# To connect using service principal
Connect-AzAccount -ServicePrincipal -Tenant <tenantId> -ApplicationId <appId> -CertificateThumbprint <thumbprint>
```

To set a default subscription:

```
Set-AzContext -Subscription <subscriptionId>
```

---

## Microsoft Intune (Endpoint Manager)

For device management and policy automation, use the **Microsoft.Graph.Intune** or Graph module.

```
# Using Microsoft Graph for Intune
Connect-MgGraph -Scopes "DeviceManagement.ReadWrite.All"
```

---

## Common Troubleshooting Tips

- Always run `Update-Module <ModuleName>` to get the latest features and bug fixes.
- Check your PowerShell execution policy:  
  `Get-ExecutionPolicy` → should be at least `RemoteSigned`.
- Enable TLS 1.2 for secure connections if you're using older systems:  
  `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12`
- If MFA is enabled, always use interactive authentication or app passwords where supported.