# Teams Toolkit

Microsoft Teams administration and troubleshooting scripts + [Commands.md](Commands.md) cheat sheet. Covers team discovery, user policies, and membership audits.

## Prerequisites
- Microsoft Teams PowerShell: `Install-Module MicrosoftTeams`
- Teams Administrator or Global Reader role
- Modern auth (Connect-MicrosoftTeams)

## Quick Connect
```
Connect-MicrosoftTeams
```

## Scripts
- **TeamSearch.ps1** - Search teams by name pattern, export members/owners
- **UserPolicies.ps1** - Teams calling, meeting, messaging policy reports
- **TeamMembership.ps1** - Bulk team membership audits and exports

## Pro Tips
- Scripts handle both V1 and new Teams PowerShell modules
- Auto-disconnects Teams session after execution
- HTML reports include direct Teams Admin Center links
- `-Recursive` parameter for nested channel membership
- Production-safe (read-only queries only)

See [Commands.md](Commands.md) for 8+ Teams troubleshooting queries.
```