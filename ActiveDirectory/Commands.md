# Active Directory Commands

Read-only troubleshooting queries for daily IT admin tasks. Assumes AD module loaded and `$PSDefaultParameterValues['*-AD*:Server'] = 'dc.server.com'`.

## User & Group Queries

| # | Purpose | Command | Explanation |
|---|---------|---------|-------------|
| 1 | Users in group | `Get-ADGroupMember -Identity "GroupName"` | Lists all direct members of specified group |
| 2 | User general info | `Get-ADUser "jdoe" -Properties MemberOf` | Full user details including group memberships |
| 3 | Nested group membership | `Get-ADUser "jdoe" -Properties MemberOf | Select -ExpandProperty MemberOf` | Shows all groups user belongs to (flattened list) |
| 4 | Users by location | `Get-ADUser "jdoe" -Properties Office` | User's office/location from AD attributes |
| 5 | Effective groups (nested) | `Get-ADPrincipalGroupMembership "jdoe"` | Shows ALL groups user effectively belongs to (recursive) |
| 6 | Users by OU | `Get-ADUser -SearchBase "OU=,DC=,DC=com" -Filter *` | Location/OU-specific user filtering |

## Account Health

| # | Purpose | Command | Explanation |
|---|---------|---------|-------------|
| 7 | Inactive users (90 days) | `Get-ADUser -Filter * -Properties LastLogonDate | Where LastLogonDate -lt (Get-Date).AddDays(-90)` | Finds dormant accounts for cleanup |
| 8 | Locked out users | `Search-ADAccount -LockedOut` | Quick list of currently locked accounts |
| 9 | Password age report | `Get-ADUser -Filter * -Properties PasswordLastSet | Select Name, PasswordLastSet` | Find users needing password changes |
| 10 | Expired passwords | `Search-ADAccount -PasswordExpired` | Users with expired passwords |
| 11 | Disabled users | `Search-ADAccount -AccountDisabled` | All disabled accounts inventory |

## Domain Infrastructure

| # | Purpose | Command | Explanation |
|---|---------|---------|-------------|
| 12 | Domain info | `Get-ADDomain` | Current domain details (FSMO, sites, etc.) |
| 13 | Forest info | `Get-ADForest` | Forest-wide configuration and FSMO roles |
| 14 | All domain controllers | `Get-ADDomainController -Filter * | Select HostName, Site, IPv4Address, OperatingSystem, IsGlobalCatalog` | Complete DC inventory by site |
| 15 | Domain FSMO roles | `Get-ADDomain | Select PDCEmulator, RIDMaster, InfrastructureMaster` | Domain FSMO holders |
| 16 | Forest FSMO roles | `Get-ADForest | Select DomainNamingMaster, SchemaMaster` | Forest-wide FSMO roles |

## Servers

| # | Purpose | Command | Explanation |
|---|---------|---------|-------------|
| 17 | Filter servers | `Get-ADComputer -Filter 'ServicePrincipalName -like "HOST/*" -and OperatingSystem -like "*Server*"'` | Finds servers by name pattern and OS |

**Pro Tips**:
- Add `| Format-Table -AutoSize` for clean tables
- Pipe to `| Export-Csv "report.csv"` for tickets
- Replace `"servername"` with your `$PSDefaultParameterValues` server
