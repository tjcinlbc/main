# Created: 2021-09-29

# This script retrieves mailboxes with active archives in Exchange Online, retrieves mailbox statistics, and exports the results to a CSV file.

# Prerequisites:
Install-Module -Name ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline



#This script iterates through every mailbox in the organization and saves a report in .csv format.
$Result=@() 
$mailboxes = Get-Mailbox -ResultSize Unlimited
$totalmbx = $mailboxes.Count
$i = 1 
$mailboxes | ForEach-Object {
$i++
$mbx = $_
$size = $null
 
Write-Progress -activity "Processing $mbx" -status "$i out of $totalmbx completed"
 
if ($mbx.ArchiveStatus -eq "Active"){
$mbs = Get-MailboxStatistics $mbx.UserPrincipalName
 
if ($mbs.TotalItemSize -ne $null){
$size = [math]::Round(($mbs.TotalItemSize.ToString().Split('(')[1].Split(' ')[0].Replace(',','')/1MB),2)
}else{
$size = 0 }
}
 
$Result += New-Object -TypeName PSObject -Property $([ordered]@{ 
ArchiveMailboxSizeInMB = $size
ArchiveName =$mbx.ArchiveName
ArchiveQuota = if ($mbx.ArchiveStatus -eq "Active") {$mbx.ArchiveQuota} Else { $null} 
ArchiveState =$mbx.ArchiveState
ArchiveStatus =$mbx.ArchiveStatus
ArchiveWarningQuota=if ($mbx.ArchiveStatus -eq "Active") {$mbx.ArchiveWarningQuota} Else { $null} 
AutoExpandingArchiveEnabled=$mbx.AutoExpandingArchiveEnabled
RetentionHoldEnabled=$mbx.RetentionHoldEnabled
UserName = $mbx.DisplayName
UserPrincipalName = $mbx.UserPrincipalName
})
}
$Result | Export-CSV "C:\Temp\Archive-Mailbox-Report.csv"
