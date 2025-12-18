<#
OneDrive File Transfer (Offboarding Tool)
Downloads entire OneDrive contents to local folder, zips it, cleans up.

Prerequisites:
- PnP.PowerShell module: Install-Module PnP.PowerShell
- SharePoint Admin / Global Admin role

Usage:
1. Get user's OneDrive URL (Admin Center > Users > OneDrive tab)
2. Edit $DownloadBasePath and connection settings
3. Run script

Author: Krish Dhungana
#>

# --- Settings (EDIT THESE for your environment) ---
$DownloadBasePath = "C:\OneDriveBackups"          # Base folder for all downloads
$OneDriveSiteURL   = Read-Host "Enter OneDrive URL (e.g. https://tenant.sharepoint.com/personal/user_domain_com)"
$FirstName         = Read-Host "User's First Name"
$LastName          = Read-Host "User's Last Name"

# Build sanitized folder structure
$UserFolder = "${FirstName.Substring(0,1).ToLower()}${LastName.ToLower()}"
$DownloadPath = Join-Path $DownloadBasePath "$UserFolder\$(Split-Path $OneDriveSiteURL -Leaf)"

# Create base folder structure
New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
Write-Host "Download folder: $DownloadPath" -ForegroundColor Cyan

$ErrorLogPath = Join-Path $DownloadPath "DownloadErrors.log"
if (Test-Path $ErrorLogPath) { Remove-Item $ErrorLogPath -Force }

try {
    # Connect to PnP (modern auth - uses browser login)
    Connect-PnPOnline -Url $OneDriveSiteURL -Interactive
    $Web = Get-PnPWeb

    # Get Documents library
    $List = Get-PnPList -Identity "Documents"
    Write-Host "Connected to OneDrive: $($Web.Title)" -ForegroundColor Green

    # Get all items with progress
    $global:counter = 0
    $ListItems = Get-PnPListItem -List $List -PageSize 500 -Fields ID -ScriptBlock {
        param($items)
        $global:counter += $items.Count
        Write-Progress -PercentComplete ($global:counter / $List.ItemCount * 100) `
            -Activity "Scanning OneDrive" -Status "Items: $global:counter / $($List.ItemCount)"
    }
    Write-Progress -Activity "Scan complete" -Completed

    # Create folder structure
    $SubFolders = $ListItems | Where-Object { $_.FileSystemObjectType -eq "Folder" -and $_.FieldValues.FileLeafRef -ne "Forms" }
    $SubFolders | ForEach-Object {
        $LocalFolder = Join-Path $DownloadPath $_.FieldValues.FileRef.Substring($Web.ServerRelativeUrl.Length) -replace "/", "\"
        if (!(Test-Path $LocalFolder)) {
            New-Item -ItemType Directory -Path $LocalFolder -Force | Out-Null
            Write-Host "Created: $LocalFolder" -ForegroundColor Yellow
        }
    }

    # Download files with progress bar + ETA
    $FilesColl = $ListItems | Where-Object { $_.FileSystemObjectType -eq "File" }
    $totalFiles = $FilesColl.Count
    $currentFile = 0
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    $FilesColl | ForEach-Object {
        $currentFile++
        $elapsed = $stopwatch.Elapsed.TotalSeconds
        $avgTimePerFile = if ($currentFile -gt 1) { $elapsed / $currentFile } else { 1 }
        $eta = ($totalFiles - $currentFile) * $avgTimePerFile
        
        Write-Progress -Activity "Downloading Files ($currentFile/$totalFiles)" `
            -Status "ETA: $([math]::Round($eta,1))s" `
            -PercentComplete (($currentFile / $totalFiles) * 100)

        try {
            $FileDownloadPath = (Join-Path $DownloadPath $_.FieldValues.FileRef.Substring($Web.ServerRelativeUrl.Length)) -replace "/", "\"
            $FileDownloadPath = Split-Path $FileDownloadPath -Parent
            Get-PnPFile -ServerRelativeUrl $_.FieldValues.FileRef -Path $FileDownloadPath -FileName $_.FieldValues.FileLeafRef -AsFile -Force
            Write-Host "✓ $($_.FieldValues.FileLeafRef)" -ForegroundColor Green
        }
        catch {
            $errorMsg = "✗ $($_.FieldValues.FileRef): $($_.Exception.Message)"
            Write-Host $errorMsg -ForegroundColor Red
            Add-Content -Path $ErrorLogPath -Value "$(Get-Date): $errorMsg"
        }
    }
    $stopwatch.Stop()
    Write-Progress -Activity "Download complete" -Completed

    # Create ZIP archive
    $zipPath = "$DownloadPath.zip"
    Compress-Archive -Path "$DownloadPath\*" -DestinationPath $zipPath -Force
    Write-Host "Archive created: $zipPath" -ForegroundColor Green

    # Cleanup (optional)
    if (Test-Path $zipPath) {
        Remove-Item $DownloadPath -Recurse -Force
        Write-Host "Cleaned up extracted files (ZIP retained)" -ForegroundColor Yellow
    }

    Disconnect-PnPOnline
    Write-Host "OneDrive transfer complete!" -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if (Test-Path $ErrorLogPath) { Write-Host "Check error log: $ErrorLogPath" -ForegroundColor Yellow }
}
