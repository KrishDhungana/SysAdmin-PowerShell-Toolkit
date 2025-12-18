<#
Copy group membership from one AD user to another.

Description:
- Prompts for a "source" user.
- Prompts for a "target" user.
- Adds the target user to all groups the source user is a member of.
- Requires appropriate permissions in AD.

Prerequisites:
- RSAT / Active Directory module installed.
- Run in a context that can modify group membership.

Usage:
- Run the script.
- Enter the source (copy from) sAMAccountName when prompted.
- Enter the target (copy to) sAMAccountName when prompted.

Author: Krish Dhungana
#>

Import-Module ActiveDirectory

# Prompt for source and target users
$SourceSam = Read-Host "Enter username to copy FROM (source)"
$TargetSam = Read-Host "Enter username to copy TO (target)"

# Basic validation
if ([string]::IsNullOrWhiteSpace($SourceSam) -or [string]::IsNullOrWhiteSpace($TargetSam)) {
    Write-Host "Source and target usernames are required. Exiting." -ForegroundColor Red
    exit 1
}

if ($SourceSam -eq $TargetSam) {
    Write-Host "Source and target cannot be the same user. Exiting." -ForegroundColor Red
    exit 1
}

try {
    # Get source user and their groups
    $sourceUser = Get-ADUser -Identity $SourceSam -Properties memberOf
} catch {
    Write-Host "Could not find source user '$SourceSam'." -ForegroundColor Red
    exit 1
}

try {
    # Validate target user exists
    $targetUser = Get-ADUser -Identity $TargetSam
} catch {
    Write-Host "Could not find target user '$TargetSam'." -ForegroundColor Red
    exit 1
}

# Extract group DNs
$groups = $sourceUser.memberOf
if (-not $groups -or $groups.Count -eq 0) {
    Write-Host "Source user '$SourceSam' is not a member of any groups (or none are returned)." -ForegroundColor Yellow
    exit 0
}

Write-Host "Copying group membership from '$SourceSam' to '$TargetSam'..." -ForegroundColor Cyan

foreach ($groupDn in $groups) {
    try {
        Add-ADGroupMember -Identity $groupDn -Members $TargetSam -ErrorAction Stop
        Write-Host "Added '$TargetSam' to group: $groupDn" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to add '$TargetSam' to group: $groupDn - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "Completed group membership copy operation." -ForegroundColor Cyan
