# ITAdmin-PowerShell Toolkit

PowerShell scripts and troubleshooting cheat sheets for hybrid IT admins managing Active Directory, Microsoft 365, Exchange Online, and Teams. Read-only queries and reporting focused on real-world tickets.

## 🚀 Quick Start

```
# Clone repo
git clone https://github.com/yourusername/ITAdmin-PowerShell.git
cd ITAdmin-PowerShell

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Review workflows first
docs/WORKFLOWS.md
```

## 📁 Modules Overview

| Module | Focus | Key Scripts | Commands |
|--------|-------|-------------|----------|
| [ActiveDirectory](ActiveDirectory/) | On-prem AD users/groups | expiringUsers.ps1, copyADGroups.ps1 | [Commands.md](ActiveDirectory/Commands.md) |
| [Microsoft365](Microsoft365/) | Entra ID hybrid sync | hybridSync.ps1, licenseCheck.ps1 | [Commands.md](Microsoft365/Commands.md) |
| [ExchangeOnline](ExchangeOnline/) | Mailbox/mail flow | messageTrace.ps1, mailboxStatus.ps1 | [Commands.md](ExchangeOnline/Commands.md) |
| [Teams](Teams/) | Team/policy audits | teamsSearch.ps1, membershipLookup.ps1 | [Commands.md](Teams/Commands.md) |
| [Utilities](Utilities/) | Cross-module helpers | UserHealthCheck.ps1, PSDefaultServer.ps1 | [Commands.md](Utilities/Commands.md) |

## 🎯 Common Workflows
See [docs/WORKFLOWS.md](docs/WORKFLOWS.md) for complete sequences:

## 📋 Prerequisites
- PowerShell 5.1+ or PowerShell 7+
- Required modules: `ActiveDirectory`, `ExchangeOnlineManagement`, `MicrosoftTeams`, `Microsoft.Graph`
- Domain/M365 read permissions

## 🛠️ Development
```
# Run all tests
Invoke-Pester

# Lint scripts
Invoke-ScriptAnalyzer -Path . -Recurse

---

**Built for MSP IT admins troubleshooting hybrid environments daily.**