# ActiveDirectory Toolkit

On-premises Active Directory scripts and [Commands.md](Commands.md) cheat sheet for hybrid IT admins. Focuses on user/group queries, OU filtering, and domain health checks.

## Prerequisites
- Active Directory PowerShell module: `Install-Module ActiveDirectory`
- Domain read access (or delegated for production)
- Domain controller connectivity (uses `$PSDefaultServer` for automation)

## Quick Connect
Import-Module ActiveDirectory
$PSDefaultParameterValues['-AD:Server'] = 'dc00.YOURSERVER.com'

## Scripts
- **UserQueries.ps1** - Export users by OU/location with custom properties
- **GroupMembership.ps1** - Nested group membership reports (direct + recursive)
- **DomainHealth.ps1** - FSMO roles, DC inventory, replication status

## Pro Tips
- All scripts output to CSV/HTML by default for ticket documentation
- Parameter `-WhatIf` available on bulk operations
- Safe for production (read-only by design)

See [Commands.md](Commands.md) for 10+ quick troubleshooting queries.