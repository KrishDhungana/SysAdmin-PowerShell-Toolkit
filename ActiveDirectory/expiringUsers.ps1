<#
Finds AD users with expired accounts or expiring soon.
Supports optional Description filter (e.g. for contractors/temp accounts).
Outputs to console table and CSV.

Prereqs:
- Import-Module ActiveDirectory (RSAT tools)

Adjust these variables at the top:
- $DaysAhead: window to flag "ExpiringSoon"
- $DescriptionFilter: set to pattern like "*CON*" or leave $null for all users
- $SearchBase: OU scope (optional, e.g. "OU=Users,DC=example,DC=com")
- $Server: target DC (optional FQDN or $null to auto-select)
- $CsvPath: export path (will auto-create folder)

Authored: Krish Dhungana
#>

Import-Module ActiveDirectory

# --- Settings (EDIT THESE for your environment) ---
$DaysAhead       = 30                                   # Flag users expiring within N days
$DescriptionFilter = $null                              # e.g. "*CON*" or "*TMP*" or $null for all users
$SearchBase      = $null                               # e.g. "OU=Users,DC=example,DC=com"
$Server          = $null                               # e.g. "dc01.example.com" or $null
$CsvPath         = "C:\Reports\ExpiringUsers.csv"      # Output file

# --- Time helpers ---
$now    = Get-Date
$cutoff = $now.AddDays($DaysAhead)

# --- Build params for Get-ADUser ---
$commonParams = @{
    Properties = @("Description","accountExpires","Enabled","whenCreated")
    Filter     = "Enabled -eq 'True'"                      # Start with enabled users (adjust as needed)
}
if ($SearchBase)      { $commonParams.SearchBase = $SearchBase }
if ($Server)          { $commonParams.Server     = $Server }
if ($DescriptionFilter) { $commonParams.Filter += " -and Description -like '$DescriptionFilter'" }

# --- Query users ---
$users = Get-ADUser @commonParams

# --- Process expiration status ---
$result = $users | ForEach-Object {
    $rawExpires = $_.accountExpires
    $expiresDt = $null
    
    # Convert FILETIME safely (0/MAX = never expires)
    if ($rawExpires -and $rawExpires -ne 0 -and $rawExpires -ne 9223372036854775807) {
        try { $expiresDt = [datetime]::FromFileTime([int64]$rawExpires) } catch {}
    }

    $daysUntil = $null
    $expired = $false
    $expiringSoon = $false
    
    if ($expiresDt) {
        $daysUntil = [math]::Floor(($expiresDt - $now).TotalDays)
        $expired = ($expiresDt -lt $now)
        $expiringSoon = (-not $expired) -and ($expiresDt -le $cutoff)
    }

    [pscustomobject]@{
        Name            = $_.Name
        SamAccountName  = $_.SamAccountName
        UserPrincipalName = $_.UserPrincipalName
        Enabled         = $_.Enabled
        Description     = $_.Description
        WhenCreated     = $_.whenCreated
        AccountExpires  = $expiresDt
        DaysUntilExpire = $daysUntil
        Expired         = $expired
        ExpiringSoon    = $expiringSoon
        NeverExpires    = -not $expiresDt
    }
}

# --- Filter to expired/expiring soon only ---
$filtered = $result | Where-Object { $_.Expired -or $_.ExpiringSoon }

# --- Console output ---
$filtered | Sort-Object Expired, ExpiringSoon, DaysUntilExpire |
    Format-Table Name, SamAccountName, Enabled, Description, AccountExpires, DaysUntilExpire, Expired, ExpiringSoon -AutoSize

# --- Export CSV (create folder if needed) ---
$dir = Split-Path -Parent $CsvPath
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$filtered | Export-Csv -Path $CsvPath -NoTypeInformation
Write-Host "Report saved: $CsvPath" -ForegroundColor Green

# --- Summary ---
Write-Host "`nSummary: $($filtered.Count) users need attention." -ForegroundColor Yellow
