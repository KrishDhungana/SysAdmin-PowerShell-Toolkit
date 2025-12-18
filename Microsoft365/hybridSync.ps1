<#
Quick Domain-Wide Delta Sync
Forces ALL changes (not just one user) to sync immediately.

Run on Entra Connect server only.

Author: Krish Dhungana
#>

Import-Module ADSync
Set-ADSyncScheduler -SyncCycleEnabled $false
Start-ADSyncSyncCycle -PolicyType Delta
Set-ADSyncScheduler -SyncCycleEnabled $true
Write-Host "Delta sync complete. Check Entra ID shortly." -ForegroundColor Green
