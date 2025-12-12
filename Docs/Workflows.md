```markdown
# Troubleshooting Workflows

Multi-module sequences for common IT admin scenarios. Combines AD, Entra ID, Exchange, and Teams queries into single workflows.

## User Lockout Investigation
**Scenario**: User reports "can't log in anywhere" across on-prem, M365, Teams.

```
1. AD Account Status → ActiveDirectory/Commands.md #3 (LockedOut, LastLogon)
2. Entra ID Sign-in Logs → Microsoft365/Commands.md #2  
3. Exchange Mailbox Access → ExchangeOnline/Commands.md #4
4. Teams Presence → Teams/Commands.md #1
```

**One-liner starter**:
```
# Run all user health checks
.\Utilities\UserHealthCheck.ps1 -UPN "jdoe@contoso.com"
```

## Hybrid User Sync Issues
**Scenario**: On-prem changes not reflecting in M365.

```
1. AD Source Object → ActiveDirectory/UserQueries.ps1
2. Entra Sync Status → Microsoft365/EntraUserSync.ps1
3. Mailbox ProxyAddresses → ExchangeOnline/MailboxStats.ps1
```

## Group Membership Audit
**Scenario**: Permissions not working across platforms.

```
1. Nested AD Groups → ActiveDirectory/GroupMembership.ps1
2. Entra Group Processing → Microsoft365/Commands.md #5
3. Teams Team Membership → Teams/TeamSearch.ps1
```

## Pro Tips
- Save outputs as `UserName-Timestamp.html` for ticket attachments
- All workflows safe for production (read-only)
- See [CONNECTIVITY.md](CONNECTIVITY.md) for session setup

**Index of All Workflows**:
| Scenario | Modules Used | Primary Script |
|----------|--------------|----------------|
| User Lockout | AD + M365 + EXO + Teams | UserHealthCheck.ps1 |
| Hybrid Sync | AD + M365 | EntraUserSync.ps1 |
| Group Audit | AD + Teams | GroupMembership.ps1 |
```