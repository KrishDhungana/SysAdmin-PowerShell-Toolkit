<#
Exchange Online Mailbox Statistics Report
Shows size, item count, last logon, quotas for all users (or filter by size/activity).

Prerequisites:
- ExchangeOnlineManagement module: Install-Module ExchangeOnlineManagement
- Global Admin / Exchange Admin role

Usage:
- Edit $SizeFilterMB, $InactiveDays for targeting
- Outputs console table + CSV

Author: Krish Dhungana
#>

# Connect (uncomment after first run)
# Connect-ExchangeOnline -ShowProgress $true

# --- Settings (EDIT THESE) ---
$SizeFilterMB  = 50          # Show mailboxes > N MB only (set to 0 for all)
$InactiveDays  = 90          # Flag inactive mailboxes
$CsvPath       = "C:\Reports\MailboxStats.csv"

# Time cutoff for inactive
$cutoffDate = (Get-Date).AddDays(-$InactiveDays)

# Get stats for user mailboxes
$mailboxes = Get-EXOMailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited |
             Get-EXOMailboxStatistics |
             Where-Object { $_.TotalItemSize.Value.ToMB() -ge $SizeFilterMB } |
             Select-Object DisplayName, UserPrincipalName, 
                           @{N='SizeMB';E={$_.TotalItemSize.Value.ToMB()}},
                           ItemCount, LastLogonTime,
                           @{N='Quota';E={$_.MailboxSizeUsed / $_.MailboxQuota}},
                           LastLogonTime

# Filter inactive
$inactive = $mailboxes | Where-Object { $_.LastLogonTime -lt $cutoffDate }

# Console output
Write-Host "Top 10 largest mailboxes:" -ForegroundColor Cyan
$mailboxes | Sort-Object SizeMB -Descending | Select-Object -First 10 | 
    Format-Table -AutoSize

if ($inactive) {
    Write-Host "`nInactive mailboxes (>$InactiveDays days):" -ForegroundColor Yellow
    $inactive | Sort-Object LastLogonTime | Format-Table -AutoSize
}

# Export all
$mailboxes | Export-Csv -Path $CsvPath -NoTypeInformation
Write-Host "Full report saved: $CsvPath" -ForegroundColor Green
