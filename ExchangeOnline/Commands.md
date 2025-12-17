# Exchange Online Commands

Read-only troubleshooting and management queries for daily M365 admin tasks.  
Assumes `ExchangeOnlineManagement` module is loaded and connected:


Connect-ExchangeOnline -UserPrincipalName admin@domain.com
```

---

## User & Mailbox Queries

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 1 | Mailbox general info | `Get-Mailbox -Identity "user@example.com"` | Basic user mailbox information |
| 2 | Detailed mailbox info | `Get-Mailbox -Identity "user@example.com" \| Format-List` | Full mailbox attributes, policies, and quotas |
| 3 | Mailbox type check | `Get-Mailbox -Identity "user@domain.com" \| Select DisplayName, RecipientTypeDetails` | Identify if mailbox is User, Shared, or Resource |
| 4 | All shared mailboxes | `Get-Mailbox -RecipientTypeDetails SharedMailbox \| Select DisplayName, PrimarySmtpAddress` | Lists all shared mailboxes in the tenant |
| 5 | Hidden from GAL | `Get-Mailbox -ResultSize Unlimited \| Where {$_.HiddenFromAddressListsEnabled -eq $true}` | Shows all mailboxes hidden from address lists |
| 6 | Unhide user mailbox | `Set-Mailbox -Identity "user@example.com" -HiddenFromAddressListsEnabled $false` | Makes mailbox visible again in the GAL |

---

## Group Management

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 7 | View M365 group details | `Get-UnifiedGroup -Identity "GroupName"` | Retrieve group configuration info |
| 8 | Check group visibility | `Get-UnifiedGroup -Identity "GroupName" \| Select DisplayName, HiddenFromAddressListsEnabled` | See if group is hidden from GAL |
| 9 | Find mail-enabled groups | `Get-Recipient -RecipientTypeDetails MailUniversalDistributionGroup,MailUniversalSecurityGroup,GroupMailbox -Filter "Name -like '*Finance*'"` | Search for groups by name pattern |
| 10 | List hidden M365 groups | `Get-UnifiedGroup -ResultSize Unlimited \| Where {$_.HiddenFromAddressListsEnabled -eq $true} \| Select DisplayName, PrimarySmtpAddress` | Displays all hidden Microsoft 365 groups |
| 11 | Group members | `Get-UnifiedGroupLinks -Identity "GroupName" -LinkType Members \| Select DisplayName, PrimarySmtpAddress` | List users in a Microsoft 365 group |

---

## Mailbox Permissions

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 12 | Who has mailbox access | `Get-MailboxPermission -Identity "user@domain.com"` | Lists all users with mailbox permissions |
| 13 | Grant Full Access | `Add-MailboxPermission -Identity "user@domain.com" -User "delegate@domain.com" -AccessRights FullAccess -InheritanceType All` | Gives delegate full mailbox access |
| 14 | Grant Send As | `Add-RecipientPermission -Identity "user@domain.com" -Trustee "delegate@domain.com" -AccessRights SendAs` | Allows delegate to send as mailbox owner |
| 15 | Grant Send on Behalf | `Set-Mailbox -Identity "user@domain.com" -GrantSendOnBehalfTo "delegate@domain.com"` | Enables delegate to send on behalf of |
| 16 | Remove Full Access | `Remove-MailboxPermission -Identity "user@domain.com" -User "delegate@domain.com" -AccessRights FullAccess -InheritanceType All -Confirm:$false` | Revokes delegate's mailbox access |
| 17 | Remove Send As | `Remove-RecipientPermission -Identity "user@domain.com" -Trustee "delegate@domain.com" -AccessRights SendAs -Confirm:$false` | Removes Send As permission |
| 18 | Remove Send on Behalf | `Set-Mailbox -Identity "user@domain.com" -GrantSendOnBehalfTo @{remove="delegate@domain.com"}` | Removes delegate’s "Send on Behalf" rights |

---

## Search & Reporting

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 19 | Find mailbox by partial name | `Get-Mailbox -ResultSize Unlimited \| Where {$_.DisplayName -like "*John*"} \| Select DisplayName, PrimarySmtpAddress` | Search for mailboxes matching a keyword |
| 20 | Mailbox quota overview | `Get-Mailbox -ResultSize Unlimited \| Select DisplayName, IssueWarningQuota, ProhibitSendQuota` | Quick quota and limit report |
| 21 | Large mailbox report | `Get-Mailbox -ResultSize Unlimited \| Get-MailboxStatistics \| Where {$_.TotalItemSize.Value -gt 10GB}` | Identify mailboxes larger than 10GB |
| 22 | Delegation report (all mailboxes) | `Get-Mailbox -ResultSize Unlimited \| ForEach { Get-MailboxPermission $_.PrimarySmtpAddress }` | Tenant-wide delegation check |
| 23 | Shared mailboxes with delegates | `Get-Mailbox -RecipientTypeDetails SharedMailbox \| ForEach { Get-MailboxPermission $_.PrimarySmtpAddress }` | All shared mailboxes with FullAccess entries |
| 24 | Export mailbox permissions | `Get-Mailbox -ResultSize Unlimited \| ForEach {Get-MailboxPermission $_.PrimarySmtpAddress} \| Export-Csv "MailboxPermissions.csv" -NoTypeInformation` | Export all mailbox permissions to CSV |

---

## Common Tips

- Add `| Format-Table -AutoSize` for easier readability.
- Use `| Export-Csv "filename.csv" -NoTypeInformation` to export results for ticketing or audits.
- Replace static user info with variables, e.g. `$User = "jdoe@example.com"`.
- For filtered outputs, use `Where-Object` or `Select-Object` to shape the data.
- Always use **MFA-enabled** accounts for production access.

---

## References

- [Microsoft Docs: ExchangeOnlineManagement Module](https://learn.microsoft.com/powershell/module/exchangeonline)
- [Manage Mailbox Permissions in Exchange Online](https://learn.microsoft.com/exchange/recipients/mailbox-permissions)
- [Microsoft 365 PowerShell Reference](https://learn.microsoft.com/powershell/exchange/)
```

***