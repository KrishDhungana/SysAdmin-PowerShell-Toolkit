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
| 1 | Tenant summary | `Get-MsolCompanyInformation` | Displays tenant name, default domain, and authentication details |
| 2 | All subscribed licenses | `Get-MsolAccountSku` | Lists available licenses (SKUs) and remaining counts |
| 3 | User license assignment overview | `Get-MsolUser -All \| Select DisplayName,UserPrincipalName,Licenses` | Shows each user's current licenses |
| 4 | Verify a specific user license | `Get-MsolUser -UserPrincipalName "user@domain.com" \| Select DisplayName,Licenses` | Check assigned license details for one user |

---

## User & Group Management

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 5 | List all Microsoft 365 groups | `Get-MgGroup -Filter "groupTypes/any(c:c eq 'Unified')"` | Returns all M365 (Unified) groups in the tenant |
| 6 | List group members | `Get-MgGroupMember -GroupId <GroupId> \| Select DisplayName,UserPrincipalName` | Lists all members of a specific group |
| 7 | Create new Microsoft 365 group | `New-MgGroup -DisplayName "IT Team" -MailEnabled $true -MailNickname "ITTeam" -SecurityEnabled $false -GroupTypes "Unified"` | Creates a new M365 group |
| 8 | Disable group guest access | `Update-MgGroup -GroupId <ID> -AllowExternalSenders $false -AutoSubscribeNewMembers $true` | Controls group sharing and join behavior |

---

## License & Compliance

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 9 | Assign license to user | `Set-MsolUserLicense -UserPrincipalName "user@domain.com" -AddLicenses "tenant:O365_BUSINESS_PREMIUM"` | Adds a license to a user |
| 10 | Remove license from user | `Set-MsolUserLicense -UserPrincipalName "user@domain.com" -RemoveLicenses "tenant:ENTERPRISEPACK"` | Revokes a license |
| 11 | Find unlicensed users | `Get-MsolUser -All \| Where { $_.IsLicensed -eq $false } \| Select DisplayName, UserPrincipalName` | Identify users without licenses |
| 12 | Conditional Access policies list *(Graph)* | `Get-MgConditionalAccessPolicy \| Select DisplayName, State, Conditions` | Lists conditional access policies with current state |

---

## Pro Tips

- The **MSOnline** module (`Connect-MsolService`) is being deprecated — move to **Microsoft Graph** (`Connect-MgGraph`) for future automation.  
- Add `| Format-Table -AutoSize` or export to `| Export-Csv "M365Report.csv"` for reports.  
- Use `Get-MgSubscribedSku` instead of `Get-MsolAccountSku` in the Graph module.
- Many Graph cmdlets allow pagination; use `-All` to retrieve full datasets.

---

## References

- [Microsoft Graph PowerShell Documentation](https://learn.microsoft.com/powershell/microsoftgraph/)
- [Manage Licenses in Microsoft 365 with PowerShell](https://learn.microsoft.com/microsoft-365/enterprise/manage-licenses)
- [Microsoft 365 PowerShell Modules Overview](https://learn.microsoft.com/powershell/office-365-module-overview)
```

***