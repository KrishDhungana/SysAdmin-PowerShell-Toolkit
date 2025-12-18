<#
Finds disabled AD users with active Microsoft 365 licenses.
Cross-references AD → Entra ID, exports to formatted Excel.

Prerequisites:
- Microsoft.Graph modules: Install-Module Microsoft.Graph.Users, Microsoft.Graph.Identity.DirectoryManagement, ImportExcel
- Connect-MgGraph -Scopes 'User.Read.All','Directory.Read.All','Directory.ReadWrite.All'

Usage:
- Edit $SearchBase for specific OU (or $null for entire domain)
- Run after Graph connection

Author: Krish Dhungana
#>

Import-Module ActiveDirectory -ErrorAction SilentlyContinue
Import-Module Microsoft.Graph.Users -ErrorAction SilentlyContinue
Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction SilentlyContinue
Import-Module ImportExcel -ErrorAction SilentlyContinue

# Test Graph connection
try { Get-MgContext | Out-Null } catch {
    Write-Error "Connect-MgGraph -Scopes 'User.Read.All,Directory.Read.All' first"
    return
}

# --- Settings (EDIT THESE) ---
$SearchBase = $null  # e.g. "OU=Users,DC=example,DC=com" or $null for entire domain
$ExportPath = "C:\Temp\DisabledUsersWithLicenses.xlsx"

# Ensure export folder
$ExportDir = Split-Path $ExportPath -Parent
if (-not (Test-Path $ExportDir)) { New-Item -Path $ExportDir -ItemType Directory -Force | Out-Null }

Write-Host "Scanning for disabled AD users with M365 licenses..." -ForegroundColor Cyan

# Get all disabled users (domain-wide or scoped)
if ($SearchBase) {
    Write-Host "Scanning OU: $SearchBase" -ForegroundColor Yellow
    $disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -SearchBase $SearchBase -Properties UserPrincipalName,SamAccountName,DisplayName -ResultSize Unlimited
} else {
    Write-Host "Scanning ENTIRE domain..." -ForegroundColor Yellow
    $disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties UserPrincipalName,SamAccountName,DisplayName -ResultSize Unlimited
}

Write-Host "Found $($disabledUsers.Count) disabled users. Checking licenses..." -ForegroundColor Cyan

# Track unique users to avoid duplicates
$userDNs = @{}
$licensedUsers = @()

foreach ($adUser in $disabledUsers) {
    # Skip if no UPN
    if ([string]::IsNullOrWhiteSpace($adUser.UserPrincipalName)) { continue }
    
    # Dedupe by DN
    if ($userDNs.ContainsKey($adUser.DistinguishedName)) { continue }
    $userDNs[$adUser.DistinguishedName] = $true

    try {
        $entraUser = Get-MgUser -UserId $adUser.UserPrincipalName -Property Id,AssignedLicenses -ErrorAction SilentlyContinue
        if ($entraUser -and $entraUser.AssignedLicenses.Count -gt 0) {
            # Resolve license names
            $licenses = foreach ($license in $entraUser.AssignedLicenses) {
                $sku = Get-MgSubscribedSku -All | Where-Object { $_.SkuId -eq $license.SkuId } | Select-Object -First 1
                $sku.SkuPartNumber
            }
            
            $licensedUsers += [PSCustomObject]@{
                DisplayName    = $adUser.DisplayName
                SamAccountName = $adUser.SamAccountName
                UPN            = $adUser.UserPrincipalName
                LicenseCount   = $entraUser.AssignedLicenses.Count
                Licenses       = ($licenses -join "; ")
                DistinguishedName = $adUser.DistinguishedName
            }
        }
    }
    catch {
        # Silently continue on Graph errors
    }
}

# Export results
if ($licensedUsers.Count -gt 0) {
    # Clear existing file
    if (Test-Path $ExportPath) { Remove-Item $ExportPath -Force -ErrorAction SilentlyContinue }
    
    $licensedUsers | Export-Excel -Path $ExportPath -AutoSize -FreezeTopRow -BoldTopRow -TableStyle Medium6 -Width 400
    Write-Host "SUCCESS: Exported $($licensedUsers.Count) licensed disabled users → $ExportPath" -ForegroundColor Green
    
    # Console preview
    Write-Host "`nTop 5 results:" -ForegroundColor Cyan
    $licensedUsers | Select-Object DisplayName, UPN, Licenses | Format-Table -AutoSize
} else {
    Write-Host "No disabled users with active licenses found." -ForegroundColor Green
}

Write-Host "Scan complete. Check $ExportPath for full results." -ForegroundColor Cyan
