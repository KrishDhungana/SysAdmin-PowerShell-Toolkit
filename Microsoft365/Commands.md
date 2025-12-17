# Microsoft 365 Commands

Common PowerShell queries and actions for tenant‑wide administration.  
Assumes connection via:

```
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","Directory.Read.All"
```
---

## Core Tenant Information

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 1 | Tenant summary | `Get-MgOrganization \| Select DisplayName, VerifiedDomains` | Displays tenant name and verified domains |
| 2 | All subscribed licenses | `Get-MgSubscribedSku \| Select SkuPartNumber, ConsumedUnits, PrepaidUnits` | Lists available licenses (SKUs) and usage |
| 3 | User license assignment | `Get-MgUser -All \| Select DisplayName,UserPrincipalName,AssignedLicenses` | Shows each user's current licenses |
| 4 | Specific user licenses | `Get-MgUser -UserId "user@domain.com" \| Select DisplayName,AssignedLicenses` | Check licenses for one user |

---

## User & Group Management

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 5 | List all M365 groups | `Get-MgGroup -Filter "groupTypes/any(c:c eq 'Unified')" \| Select DisplayName,GroupTypes` | Returns all Microsoft 365 groups |
| 6 | List group members | `Get-MgGroupMember -GroupId <GroupId> \| Get-MgUser \| Select DisplayName,UserPrincipalName` | Lists members of specific group |
| 7 | All users report | `Get-MgUser -All \| Select DisplayName,UserPrincipalName,AccountEnabled \| Export-Csv Users.csv` | Exports complete user list |
| 8 | Guest users only | `Get-MgUser -Filter "userType eq 'Guest'" \| Select DisplayName,UserPrincipalName` | Lists all external/guest users |

---

## License & Admin Management

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 9 | Unlicensed users | `Get-MgUser -All \| Where-Object {$_.AssignedLicenses.Count -eq 0} \| Select DisplayName,UserPrincipalName` | Find users without licenses |
| 10 | License usage report | `Get-MgSubscribedSku \| ForEach {Get-MgSubscribedSku -SubscribedSkuId $_.Id} \| Select SkuPartNumber,ConsumedUnits` | Detailed license consumption |
| 11 | Admin role members | `Get-MgDirectoryRole \| Where DisplayName -eq "Global Administrator" \| Get-MgDirectoryRoleMemberByRef` | Lists Global Admin role holders |
| 12 | Blocked sign-in users | `Get-MgUser -Filter "accountEnabled eq false" \| Select DisplayName,UserPrincipalName` | Users with sign-in blocked |

---

## Pro Tips

- **Install Graph module**: `Install-Module Microsoft.Graph -Scope CurrentUser`
- **MSOnline/AzureAD are deprecated** — Graph is the future-proof choice.
- Use `-All` or `-PageSize 999` for large tenants.
- Add `| Format-Table -AutoSize` or `| Export-Csv` for reporting.
- Required scopes: `Directory.Read.All`, `User.Read.All`, `Group.Read.All`.

---

## References

- [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/overview)
- [Get started with Microsoft Graph PowerShell](https://learn.microsoft.com/powershell/microsoftgraph/get-started)


***