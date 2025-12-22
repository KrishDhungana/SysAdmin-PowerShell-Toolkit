<#
Disk Error Scanner
Checks system drive for errors using chkdsk/repair-volume. Returns exit codes for automation.

Version: 2.0
Run as: SYSTEM / Admin
Usage: Task Scheduler + SCCM / Intune
Exit Codes: 0=Clean, 1=Errors, 2=ScanFailed

Author: Krish Dhungana
#>

$SystemDrive = ($env:SystemDrive).Substring(0,1)
$LogPath = "C:\Temp\DiskScan_$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

# Ensure log dir
$LogDir = Split-Path $LogPath -Parent
if (-not (Test-Path $LogDir)) { New-Item -Path $LogDir -ItemType Directory -Force | Out-Null }

Write-Output "Scanning $SystemDrive for disk errors..." | Tee-Object -FilePath $LogPath

try {
    # Method 1: repair-volume (Server 2016+ / Win10+)
    $repairResult = Repair-Volume -DriveLetter $SystemDrive -Scan -Verbose -ErrorAction Stop
    
    # Parse result properly (not string comparison)
    if ($repairResult.OperationStatus -eq "NoErrorsFound") {
        Write-Host "No disk errors found" -ForegroundColor Green
        Write-Output "Clean" | Tee-Object -FilePath $LogPath -Append
        exit 0
    }
    elseif ($repairResult.OperationStatus -eq "RepairScanCompleted") {
        Write-Host "Errors found - repair needed" -ForegroundColor Yellow
        Write-Output "ErrorsDetected" | Tee-Object -FilePath $LogPath -Append
        exit 1
    }
}
catch {
    Write-Warning "Repair-Volume failed, falling back to chkdsk: $($_.Exception.Message)"
    
    # Method 2: chkdsk fallback (universal)
    $chkdsk = & chkdsk.exe /scan $SystemDrive 2>&1
    
    if ($chkdsk -match "0 KB in bad sectors") {
        Write-Host "CHKDSK: No errors" -ForegroundColor Green
        $chkdsk | Tee-Object -FilePath $LogPath -Append
        exit 0
    }
    else {
        Write-Host "CHKDSK: Errors detected" -ForegroundColor Red
        $chkdsk | Tee-Object -FilePath $LogPath -Append
        exit 1
    }
}

Write-Host "Scan failed" -ForegroundColor Red
exit 2
