# Active Directory Commands

Read-only troubleshooting queries. Assumes AD module loaded.

| # | Purpose | Command | Explanation |
|---|---------|---------|-------------|
| 1 | Full user attributes | `Get-ADUser "jdoe" -Properties * | Select SamAccountName, Enabled, LastLogonDate` | Snapshot for lockout/password issues |
| 2 | Nested group membership | `Get-ADPrincipalGroupMembership "jdoe" | Select Name, GroupScope` | Effective groups for permissions audit |
| 3 | FSMO roles | `Get-ADForest | Select DomainNamingMaster, SchemaMaster` | Forest replication health |
| 4 | DCs by site | `Get-ADDomainController -Filter * | Select Name, Site, IsGlobalCatalog` | Site-specific controller inventory |
| 5 | Users by OU | `Get-ADUser -SearchBase "OU=Chicago,DC=contoso,DC=com" -Filter *` | Location-based user filtering |

**Pro Tip**: Add `| Format-Table -AutoSize` or `| Export-Csv users.csv` to any command.
