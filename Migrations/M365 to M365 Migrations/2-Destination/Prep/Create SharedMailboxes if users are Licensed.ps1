# Connect to Exchange Online
Connect-ExchangeOnline

# Import the list of mailboxes to be converted from a CSV file
$MailboxList = Import-Csv -Path "C:\temp\SharedMailboxes.csv"

foreach ($Mailbox in $MailboxList) {
    try {
        # Convert the mailbox to a shared mailbox
        Set-Mailbox -Identity $Mailbox.PrimarySMTPAddress -Type Shared
        Write-Host "Successfully converted $($Mailbox.PrimarySMTPAddress) to a shared mailbox."
    } catch {
        Write-Host "Failed to convert $($Mailbox.PrimarySMTPAddress) to a shared mailbox: $($_.Exception.Message)"
    }
}