#Create Shared Mailboxes from CSV

Connect-ExchangeOnline

# Initialize errors array
$errors = @()
# Export the shared mailbox list to a CSV file
$SharedList | Export-Csv -Path "C:\temp\SharedMailboxes.csv" -NoTypeInformation

foreach ($Item in $SharedList) {
    try {
        # Check if the mailbox already exists
        $existingMailbox = Get-Mailbox -Identity $Item.NewAddress -ErrorAction SilentlyContinue
        if ($existingMailbox) {
            Write-Host "Mailbox for $($Item.DisplayName) already exists."
        } else {
            # Create the shared mailbox
            New-MailBox -Shared -Name $Item.DisplayName -PrimarySMTPAddress $Item.NewAddress -Alias $Item.Alias -DisplayName $Item.DisplayName
            Write-Host "Successfully created mailbox for $($Item.DisplayName)"
        }
    } catch {
        $errorMessage = "Failed to create mailbox for $($Item.DisplayName): $($_.Exception.Message)"
        $errors += $errorMessage
        Write-Host $errorMessage
    }
}

# Report on the creation process
if ($errors.Count -eq 0) {
    Write-Host "All mailboxes created successfully."
} else {
    Write-Host "Some mailboxes were not created due to errors:"
    foreach ($error in $errors) {
        Write-Host $error
    }
}