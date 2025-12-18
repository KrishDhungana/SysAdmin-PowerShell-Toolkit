<#
Exchange Online Message Trace (Last 24 hours)
Searches all mail by sender/recipient/subject. Exports detailed trace.

Prerequisites:
- ExchangeOnlineManagement module
- Exchange Admin role

Usage:
- Edit search criteria below
- Supports wildcards (*)

Author: Krish Dhungana
#>

# Connect (uncomment after first run)
# Connect-ExchangeOnline

# --- Settings (EDIT THESE) ---
$StartDate  = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")  # Last 24h
$EndDate    = (Get-Date).ToString("yyyy-MM-dd")
$Sender     = "*"                  # e.g. "user@domain.com" or "*"
$Recipient  = "*"                  # e.g. "helpdesk@domain.com"
$Subject    = "*"                  # e.g. "*invoice*"
$CsvPath    = "C:\Reports\MessageTrace.csv"

# Run trace
$trace = Get-EXOMessageTrace -StartDate $StartDate -EndDate $EndDate `
                             -SenderAddress $Sender -RecipientAddress $Recipient `
                             -MessageSubject $Subject -PageSize 5000

if ($trace.Count -eq 0) {
    Write-Host "No messages found matching criteria." -ForegroundColor Yellow
    exit
}

# Detailed results
$details = $trace | ForEach-Object { Get-EXOMessageTraceDetail -MessageTraceId $_.MessageTraceId } |
           Select-Object SenderAddress, RecipientAddress, Subject, Status, 
                         Received, Sent, Size, MessageId, NetworkMessageId

# Console summary
Write-Host "Found $($details.Count) messages. Top statuses:" -ForegroundColor Cyan
$details | Group-Object Status | Sort-Object Count -Descending | 
    Select-Object Name, Count | Format-Table -AutoSize

# Export
$details | Export-Csv -Path $CsvPath -NoTypeInformation
Write-Host "Detailed trace saved: $CsvPath" -ForegroundColor Green
