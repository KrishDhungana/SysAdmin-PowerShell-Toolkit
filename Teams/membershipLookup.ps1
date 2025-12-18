<#
Teams User Membership Lookup
Shows ALL teams + channels + roles for a single user.

Prerequisites:
- MicrosoftTeams module
- Connect-MicrosoftTeams

Usage: .\TeamsUserMembership.ps1 -User "jdoe@company.com"

Author: Krish Dhungana
#>

param([string]$User = (Read-Host "Enter UPN or name"))

Connect-MicrosoftTeams  # Uncomment after first run

Write-Host "Teams membership for: $User" -ForegroundColor Cyan

# 1. Get all TEAMS user is in
$Teams = Get-Team -User $User
Write-Host "`n--- TEAMS ($($Teams.Count)) ---" -ForegroundColor Yellow
$Teams | Select-Object DisplayName, GroupId, Visibility | Format-Table -AutoSize

# 2. Get detailed membership per team
foreach ($Team in $Teams) {
    Write-Host "`n$($Team.DisplayName):" -ForegroundColor Green
    Get-TeamUser -GroupId $Team.GroupId -User $User | 
        Select-Object Name, Role | Format-Table -AutoSize
    
    # Channels (owners see all, members see joined)
    $Channels = Get-TeamChannel -GroupId $Team.GroupId
    Write-Host "  Channels ($($Channels.Count)):" -ForegroundColor Gray
    $Channels | Select-Object DisplayName | Format-Table Name -AutoSize
}

Write-Host "`nDone." -ForegroundColor Cyan
