# ITAdmin-PowerShell Toolkit

PowerShell scripts and troubleshooting cheat sheets for hybrid IT admins managing Active Directory, Microsoft 365, Exchange Online, and Teams. Read-only queries and reporting focused on real-world tickets.

[![PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer/workflows/pSA/badge.svg)](https://github.com/PowerShell/PSScriptAnalyzer)
[![Pester Tests](https://github.com/yourusername/ITAdmin-PowerShell/workflows/Pester/badge.svg)](https://github.com/yourusername/ITAdmin-PowerShell/actions)

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
| [ActiveDirectory](ActiveDirectory/) | On-prem AD users/groups | UserQueries.ps1, GroupMembership.ps1 | [Commands.md](ActiveDirectory/Commands.md) |
| [Microsoft365](Microsoft365/) | Entra ID hybrid sync | EntraUserSync.ps1, ConditionalAccess.ps1 | [Commands.md](Microsoft365/Commands.md) |
| [ExchangeOnline](ExchangeOnline/) | Mailbox/mail flow | MailboxStats.ps1, MessageTrace.ps1 | [Commands.md](ExchangeOnline/Commands.md) |
| [Teams](Teams/) | Team/policy audits | TeamSearch.ps1, UserPolicies.ps1 | [Commands.md](Teams/Commands.md) |
| [Utilities](Utilities/) | Cross-module helpers | UserHealthCheck.ps1, PSDefaultServer.ps1 | [Commands.md](Utilities/Commands.md) |

## 🎯 Common Workflows
See [docs/WORKFLOWS.md](docs/WORKFLOWS.md) for complete sequences:

- **User Lockout**: `.\Utilities\UserHealthCheck.ps1 -UPN "jdoe@contoso.com"`
- **Hybrid Sync**: `.\Microsoft365\EntraUserSync.ps1`
- **Team Audit**: `.\Teams\TeamSearch.ps1 -TeamName "*sales*"`

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

# Update help
platyPS\Update-MarkdownHelp.ps1 -Path .\docs\
```

## 🤝 Contributing
1. Fork → Clone → Branch (`git checkout -b feature/user-queries`)
2. Add scripts/tests → `Invoke-Pester`
3. Commit → PR with ticket scenario

## 📄 License
MIT License - see [LICENSE](LICENSE) © 2025

---

**Built for MSP IT admins troubleshooting hybrid environments daily.**