# Utilities Toolkit

General PowerShell helpers and cross-module automation scripts + [Commands.md](Commands.md) cheat sheet. AD server defaults, reporting formats, user health checks.

## Prerequisites
- PowerShell 5.1+ (native modules only, no external dependencies)
- Works with any AD/EXO/Teams session

## Quick Start
```
# Set default AD server (one-time per session)
.\PSDefaultServer.ps1 -ServerName "dc01.contoso.com"

# Global user health check across all platforms
.\UserHealthCheck.ps1 -UPN "jdoe@contoso.com"
```

## Scripts
- **PSDefaultServer.ps1** - Auto-configure AD server for all cmdlets
- **ExportReports.ps1** - Standardized CSV/HTML/PDF output formatting
- **UserHealthCheck.ps1** - Single-command AD + Entra + EXO + Teams audit

## Usage Examples
```
# Set AD server globally (no more -Server parameter needed)
.\PSDefaultServer.ps1 -ServerName "dc01.contoso.com" -PersistToProfile

# Pretty HTML report from any query
Get-ADUser "jdoe" | .\ExportReports.ps1 -Format HTML -Path "jdoe-report.html"

# Complete user troubleshooting (runs all modules)
.\UserHealthCheck.ps1 -UPN "jdoe@contoso.com" -OutputPath "jdoe-full-audit.html"
```

## Pro Tips
- **PSDefaultServer.ps1** adds to your `$PROFILE` for permanent sessions
- All utilities parameterize output paths and formats (CSV/HTML/JSON)
- **UserHealthCheck.ps1** auto-connects required modules if missing
- No credentials needed (uses current session context)
- Safe for all environments (read-only, no modifications)

See [Commands.md](Commands.md) for general PowerShell one-liners and formatting tricks.
```