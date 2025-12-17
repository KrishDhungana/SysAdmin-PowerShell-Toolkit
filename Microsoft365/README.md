# Microsoft365 Toolkit

Entra ID (Azure AD) and Microsoft 365 hybrid administration scripts + [Commands.md](Commands.md) cheat sheet. Focuses on sync, licensing, and Conditional Access auditing.

## Prerequisites
- Microsoft Graph PowerShell: `Install-Module Microsoft.Graph`
- Entra ID P2 or Global Reader role minimum
- Hybrid environments: Azure AD Connect health permissions

## Quick Connect
```
Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","Directory.Read.All"
```

## Scripts
- **EntraUserSync.ps1** - Hybrid join status, sync errors, source anchor validation
- **ConditionalAccess.ps1** - Policy audits, MFA enforcement reports
- **LicensingReport.ps1** - License assignment/expiration tracking

## Pro Tips
- Scripts use delegated permissions (no app registrations needed)
- Auto-refreshes Graph tokens during long-running reports
- Includes on-prem AD correlation for hybrid troubleshooting
- Outputs include direct Admin Center links for remediation

See [Commands.md](Commands.md) for Entra ID/Graph troubleshooting queries.S