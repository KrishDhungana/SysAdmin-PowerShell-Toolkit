<#
Intune BitLocker Key Search
Finds specific device(s) in Intune + shows escrowed recovery keys.

Prerequisites:
- Microsoft.Graph.Intune module
- Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All","BitlockerKey.Read.All"

Author: Krish Dhungana
#>

param([string]$DeviceName = (Read-Host "Enter device name, serial, or ID"))

# Test connection
try { Get-MgContext | Out-Null } catch {
    Write-Error "Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All,BitlockerKey.Read.All' first"
    return
}

Write-Host "Searching Intune for '$DeviceName'..." -ForegroundColor Cyan

# Search Intune devices
$Devices = Get-MgDeviceManagementManagedDevice -Filter "contains(deviceName,'$DeviceName') or contains(serialNumber,'$DeviceName') or contains(deviceId,'$DeviceName')" -All

if ($Devices.Count -eq 0) {
    Write-Host "No devices found matching '$DeviceName'" -ForegroundColor Yellow
    return
}

foreach ($Device in $Devices) {
    Write-Host "`n=== $($Device.DeviceName) ($($Device.SerialNumber)) ===" -ForegroundColor Cyan
    
    # Get BitLocker keys for this device
    $Keys = Get-MgInformationProtectionBitlockerRecoveryKey -Filter "deviceId eq '$($Device.Id)'"
    
    if ($Keys) {
        foreach ($Key in $Keys) {
            Write-Host "Key ID: $($Key.Id)" -ForegroundColor Yellow
            Write-Host "Recovery Key: $($Key.RecoveryKey)" -ForegroundColor Green
            Write-Host "---" -ForegroundColor Gray
        }
    } else {
        Write-Host "NO RECOVERY KEY ESCROWED" -ForegroundColor Red
    }
}

Write-Host "`nCopy keys above for user support." -ForegroundColor Gray
