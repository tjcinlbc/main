#Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
Connect-ExchangeOnline

# Specify the UPN of the user to enable the online archive for
$user = "cspadmin@contoso.onmicrosoft.com"

# Check the current archive status for the mailbox
Get-Mailbox -Identity $user | FL UserPrincipalName,ArchiveStatus,ArchiveDatabase,ArchiveQuota,ArchiveWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,IssueWarningQuota,AutoExpandingArchiveEnabled,ArchiveState,ArchiveName,RetentionHoldEnabled
# Enable the online archive for the mailbox
Enable-Mailbox -Identity $user -Archive
# Enable auto expanding archive
#Enable-Mailbox -Identity $user -AutoExpandingArchive
# Set the archive quota and warning quota
#Set-Mailbox -Identity $user -ArchiveQuota 100GB -ArchiveWarningQuota 90GB
# Set the mailbox to 100GB
Set-Mailbox -Identity $user -ProhibitSendQuota 100GB -ProhibitSendReceiveQuota 100GB -IssueWarningQuota 90GB
# Kick off email Archive process to move email to online archive
Start-ManagedFolderAssistant –Identity $user

# May help with online archive processing issues
#Set-Mailbox -Identity $user -ElcProcessingDisabled $false
