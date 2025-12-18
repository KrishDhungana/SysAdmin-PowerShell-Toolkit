<#
Teams Universal Search
Finds teams, channels, users, apps by keyword. Perfect for "where is that channel?" support calls.

Prerequisites:
- MicrosoftTeams module: Install-Module MicrosoftTeams
- Connect-MicrosoftTeams

Usage:
- Run and enter search term (supports wildcards *)
- Outputs console table + CSV export

Author: Krish Dhungana
#>

param([string]$SearchTerm, [switch]$Export)

Connect-MicrosoftTeams  # Uncomment after first run

if (-not $SearchTerm) {
    $SearchTerm = Read-Host "Enter search term (e.g. 'project', 'sales*', 'john*')"
}

Write-Host "Searching Teams for: '$SearchTerm'" -ForegroundColor Cyan

$Results = @()

# 1. Search TEAMS
Write-Host "`n--- TEAMS ---" -ForegroundColor Yellow
$Teams = Get-Team | Where-Object { $_.DisplayName -like "*$SearchTerm*" -or $_.MailNickname -like "*$SearchTerm*" }
foreach ($Team in $Teams) {
    $Results += [PSCustomObject]@{
        Type = "TEAM"
        Name = $Team.DisplayName
        ID   = $Team.GroupId
        Description = $Team.Description
        Visibility = $Team.Visibility
    }
}

# 2. Search CHANNELS (across matching teams)
Write-Host "`n--- CHANNELS ---" -ForegroundColor Yellow
foreach ($Team in $Teams) {
    $Channels = Get-TeamChannel -GroupId $Team.GroupId | Where-Object { $_.DisplayName -like "*$SearchTerm*" }
    foreach ($Channel in $Channels) {
        $Results += [PSCustomObject]@{
            Type = "CHANNEL"
            Name = "$($Team.DisplayName) / $($Channel.DisplayName)"
            ID   = $Channel.Id
            Description = $Channel.Description
        }
    }
}

# 3. Search USERS in matching teams
Write-Host "`n--- USERS ---" -ForegroundColor Yellow
foreach ($Team in $Teams) {
    $Users = Get-TeamUser -GroupId $Team.GroupId | Where-Object { $_.Name -like "*$SearchTerm*" -or $_.User -like "*$SearchTerm*" } | Select-Object -First 10
    foreach ($User in $Users) {
        $Results += [PSCustomObject]@{
            Type = "USER"
            Name = $User.Name
            ID   = $User.User
            Description = $User.Role
        }
    }
}

# 4. Search APPS (if keyword matches)
Write-Host "`n--- APPS ---" -ForegroundColor Yellow
$Apps = Find-CsOnlineApplicationInstance -SearchQuery $SearchTerm -MaxResults 5
foreach ($App in $Apps) {
    $Results += [PSCustomObject]@{
        Type = "APP"
        Name = $App.DisplayName
        ID   = $App.Id
        Description = $App.TelephoneNumber
    }
}

# Results summary
Write-Host "`n=== RESULTS ($($Results.Count) found) ===" -ForegroundColor Cyan
$Results | Sort-Object Type, Name | Format-Table Type, Name, Description -AutoSize -Wrap

# Export if requested
if ($Export -or $Results.Count -gt 0) {
    $ExportPath = "C:\Temp\TeamsSearch_$($SearchTerm -replace '[^\w]','_').csv"
    $Results | Export-Csv $ExportPath -NoTypeInformation
    Write-Host "Exported to: $ExportPath" -ForegroundColor Green
}

Write-Host "`nPro tip: Use wildcards like 'sales*', '2024*', 'john*'" -ForegroundColor Gray
