# Microsoft Teams Commands

Common PowerShell commands for managing Microsoft Teams owners, members, settings, and lifecycle tasks.  
Assumes Teams module is installed and connected:

```
Connect-MicrosoftTeams
```

---

## Team Discovery & Membership

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 1 | Search for a Team | `Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}` | Finds any team matching part of a name |
| 2 | Get team by ID | `Get-Team -GroupId <GroupID>` | Retrieves specific team information |
| 3 | List all teams | `Get-Team \| Select DisplayName, GroupId, Visibility` | Lists all Teams with their visibility level |
| 4 | Get owners only | `Get-TeamUser -GroupId (Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}).GroupId \| Where-Object {$_.Role -eq "Owner"}` | Lists users with Owner role in a given team |
| 5 | Get members only | `Get-TeamUser -GroupId (Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}).GroupId \| Where-Object {$_.Role -eq "Member"}` | Lists standard members of the specified team |

---

## Membership Management

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 6 | Add member | `Add-TeamUser -GroupId (Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}).GroupId -User "user@domain.com" -Role Member` | Adds a user to the team as a Member |
| 7 | Add owner | `Add-TeamUser -GroupId (Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}).GroupId -User "user@domain.com" -Role Owner` | Elevates or adds a user as Owner |
| 8 | Remove user | `Remove-TeamUser -GroupId (Get-Team \| Where-Object {$_.DisplayName -like "*TeamName*"}).GroupId -User "user@domain.com"` | Removes a user from a team |
| 9 | Change user role | `Add-TeamUser -GroupId <GroupId> -User "user@domain.com" -Role Owner` | Re‑adds member as owner to change their role |
| 10 | List guest users | `Get-TeamUser -GroupId <GroupId> \| Where {$_.User -like "*#EXT#*"} \| Select User, Role` | Identifies Teams guests and their roles |

---

## Administration & Reporting

| # | Purpose | Command | Explanation |
|---|----------|----------|-------------|
| 11 | Team settings overview | `Get-Team -GroupId <GroupId> \| Format-List*` | Shows settings such as visibility, archived state, and fun settings |
| 12 | Export all Teams summary | `Get-Team \| Select DisplayName, Visibility, Archived, Description \| Export-Csv TeamsList.csv -NoTypeInformation` | Exports tenant’s team list for reporting or audits |

---

## Pro Tips

- Run `Update-Module MicrosoftTeams` to get the latest Graph‑based cmdlets.
- Use variables to simplify repeated commands:  
  ```
  $Team = Get-Team -DisplayName "IT Support"
  Get-TeamUser -GroupId $Team.GroupId
  ```
- Use `Get-TeamChannel` and `Add-TeamChannel` for channel‑level management if you need finer control.
- Replace manual `Where-Object` searches with direct `-DisplayName` filters when possible to improve speed.
- Include `| Format-Table -AutoSize` or `| Export-Csv` when reviewing large outputs.

---