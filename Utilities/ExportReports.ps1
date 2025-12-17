<#
.SYNOPSIS
    SysAdmin PowerShell Toolkit - ExportReports.ps1
    
    Central utility to generate common read-only reports from AD, Exchange, Teams, and M365.
    Creates timestamped CSV files in ./Reports folder for ticketing/audits.

.PARAMETER Reports
    AD, Exchange, Teams, M365, or All (default)

.PARAMETER OutputPath
    Folder for CSV exports (default: ./Reports)

.EXAMPLE
    .\ExportReports.ps1 -Reports All
    .\ExportReports.ps1 -Reports Exchange,AD -OutputPath C:\Reports
#>

[CmdletBinding()]
param(
    [ValidateSet('AD','Exchange','Teams','M365','All')]
    [string[]]$Reports = 'All',
    
    [string]$OutputPath = ".\Reports"
)

# Create output folder
if (!(Test-Path $OutputPath)) { New-Item $OutputPath -ItemType Directory | Out-Null }

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Write-Host "=== SysAdmin Report Export ($Timestamp) ===" -ForegroundColor Green

# AD Reports
if ($Reports -contains 'AD' -or $Reports -eq 'All') {
    Write-Host "Exporting AD reports..." -ForegroundColor Yellow
    Search-ADAccount -AccountDisabled | Export-Csv "$OutputPath\AD_Disabled_$Timestamp.csv" -NoTypeInformation
    Get-ADUser -Filter * -Properties LastLogonDate | Where LastLogonDate -lt (Get-Date).AddDays(-90) | Export-Csv "$OutputPath\AD_Inactive90_$Timestamp.csv" -NoTypeInformation
}

# Exchange Reports
if ($Reports -contains 'Exchange' -or $Reports -eq 'All') {
    Write-Host "Exporting Exchange reports..." -ForegroundColor Yellow
    Get-Mailbox -ResultSize Unlimited | Select DisplayName,PrimarySmtpAddress,RecipientTypeDetails | Export-Csv "$OutputPath\EXO_Mailboxes_$Timestamp.csv" -NoTypeInformation
    Get-Mailbox -RecipientTypeDetails SharedMailbox | ForEach {Get-MailboxPermission $_.PrimarySmtpAddress} | Export-Csv "$OutputPath\EXO_SharedPermissions_$Timestamp.csv" -NoTypeInformation
}

# Teams Reports
if ($Reports -contains 'Teams' -or $Reports -eq 'All') {
    Write-Host "Exporting Teams reports..." -ForegroundColor Yellow
    Get-Team | Select DisplayName,Visibility,GroupId | Export-Csv "$OutputPath\Teams_List_$Timestamp.csv" -NoTypeInformation
}

# M365 Reports
if ($Reports -contains 'M365' -or $Reports -eq 'All') {
    Write-Host "Exporting M365 reports..." -ForegroundColor Yellow
    Get-MsolAccountSku | Export-Csv "$OutputPath\M365_Licenses_$Timestamp.csv" -NoTypeInformation
}

Write-Host "Reports exported to $OutputPath" -ForegroundColor Green
Write-Host "Files: $(Get-ChildItem $OutputPath\*$Timestamp.csv | Select -Expand Name)" -ForegroundColor Cyan
```

# **Usage:** Save as `Utilities/ExportReports.ps1`. Run with `.\ExportReports.ps1 -Reports All` to generate everything