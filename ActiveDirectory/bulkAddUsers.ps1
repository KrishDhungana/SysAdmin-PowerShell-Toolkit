<#
Bulk Add Users to AD Groups from CSV
Supports: Multiple users → multiple groups per row
CSV format: UserSam,Group1,Group2,Group3... (or single group per row)

Prerequisites:
- Active Directory module (RSAT)
- CSV file with header: UserSam,GroupName1,GroupName2,... (comma-separated groups)

Example users.csv:
UserSam,GroupName
jdoe,Finance,HR
jsmith,IT-Admins,Helpdesk
jdoe,Marketing

Usage:
1. Edit $CsvPath to your file
2. Run with -WhatIf first (dry run)
3. Remove -WhatIf to execute

Author: Krish Dhungana
#>

param(
    [string]$CsvPath = "C:\Reports\UsersToGroups.csv",
    [switch]$WhatIf
)

Import-Module ActiveDirectory

if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv $CsvPath

$totalProcessed = 0
$addedCount = 0
$skippedCount = 0

foreach ($user in $users) {
    $userSam = $user.UserSam
    
    # Validate user exists and is enabled
    try {
        $adUser = Get-ADUser -Identity $userSam -Properties Enabled
        if (-not $adUser.Enabled) {
            Write-Host "SKIPPED (disabled): $userSam" -ForegroundColor Yellow
            $skippedCount++
            continue
        }
    } catch {
        Write-Host "SKIPPED (not found): $userSam" -ForegroundColor Red
        $skippedCount++
        continue
    }

    # Process all groups for this user (handles multiple per row)
    $groups = @($user.PSObject.Properties | Where-Object { $_.Name -ne 'UserSam' -and $_.Value } | ForEach-Object { $_.Value })
    
    foreach ($groupName in $groups) {
        try {
            # Check if already member
            if (Get-ADGroupMember -Identity $groupName -Members $userSam -ErrorAction SilentlyContinue) {
                Write-Host "ALREADY MEMBER: $userSam → $groupName" -ForegroundColor Cyan
                continue
            }

            # Add user to group
            Add-ADGroupMember -Identity $groupName -Members $userSam -WhatIf:$WhatIf -ErrorAction Stop
            Write-Host "ADDED: $userSam → $groupName" -ForegroundColor Green
            $addedCount++
        }
        catch {
            Write-Host "FAILED: $userSam → $groupName - $($_.Exception.Message)" -ForegroundColor Red
        }
        $totalProcessed++
    }
}

Write-Host "`nSummary: $addedCount added, $skippedCount skipped, $totalProcessed total operations" -ForegroundColor Cyan
