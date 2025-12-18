<#
Simple Drive Mapper
Maps common network drives. Edit $Drives array below.

Usage: Run as user (logon script ready)

Author: Krish Dhungana
#>

$Drives = @(
    @{Letter="H"; Path="\\fileserver\home\$env:USERNAME"},
    @{Letter="S"; Path="\\fileserver\shared"},
    @{Letter="G"; Path="\\fileserver\groups"},
    @{Letter="P"; Path="\\fileserver\public"}
)

Write-Host "Mapping drives..." -ForegroundColor Cyan

foreach ($Drive in $Drives) {
    # Remove if exists
    if (Get-PSDrive -Name $Drive.Letter -ErrorAction SilentlyContinue) {
        Remove-PSDrive -Name $Drive.Letter -Force -ErrorAction SilentlyContinue
    }
    
    # Map new drive
    try {
        New-PSDrive -Name $Drive.Letter -PSProvider FileSystem -Root $Drive.Path -Persist
        Write-Host "✓ $($Drive.Letter): mapped" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ $($Drive.Letter): failed" -ForegroundColor Red
    }
}

Write-Host "Done. Check File Explorer." -ForegroundColor Cyan
