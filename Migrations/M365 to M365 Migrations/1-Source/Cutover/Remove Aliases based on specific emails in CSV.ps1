# Read the CSV file containing the user principal names (UPNs) and their email aliases
$upnList = Import-Csv -Path "C:\temp\aliasesfinal.csv"

# Loop through each record in the CSV
foreach ($user in $upnList) {
    # Check if email1 is not null or empty
    if (![string]::IsNullOrWhiteSpace($user.email1)) {
        # Prepare the email1 address for removal by stripping any potential 'smtp:' prefix
        $removeEmail1 = $user.email1 -replace "smtp:", ""
        # Update the mailbox to remove email1
        Set-Mailbox -Identity $user.NewUPN -EmailAddresses @{Remove=$removeEmail1}
    }

    # Check if email2 is not null or empty
    if (![string]::IsNullOrWhiteSpace($user.email2)) {
        # Prepare the email2 address for removal by stripping any potential 'smtp:' prefix
        $removeEmail2 = $user.email2 -replace "smtp:", ""
        # Update the mailbox to remove email2
        Set-Mailbox -Identity $user.NewUPN -EmailAddresses @{Remove=$removeEmail2}
    }
}