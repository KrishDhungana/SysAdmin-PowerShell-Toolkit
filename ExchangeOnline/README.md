# ExchangeOnline Toolkit

Exchange Online mailbox management and mail flow troubleshooting scripts + [Commands.md](Commands.md) cheat sheet. Covers hybrid and cloud-only environments.

## Prerequisites
- Exchange Online PowerShell V3: `Install-Module ExchangeOnlineManagement`
- Microsoft 365 read-only role (Mailbox Search, View-Only Recipients)
- Modern auth (no basic auth required)

## Quick Connect
```
Connect-ExchangeOnline -UserPrincipalName admin@contoso.com
```

## Scripts
- **MailboxStats.ps1** - Mailbox size, permissions, last logon reports
- **MessageTrace.ps1** - Mail flow tracking with custom date ranges
- **FolderPermissions.ps1** - Calendar/Delegates auditing

## Pro Tips
- Scripts auto-disconnect session after execution (`Disconnect-ExchangeOnline`)
- HTML outputs include clickable links to admin center
- `-DaysBack` parameter for quick historical traces (default: 7 days)
- Safe for production tenants (read-only operations only)

See [Commands.md](Commands.md) for 10+ quick EXO troubleshooting queries.