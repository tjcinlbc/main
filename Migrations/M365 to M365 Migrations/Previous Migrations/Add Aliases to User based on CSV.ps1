Install-Module -Name ExchangeOnlineManagement -Force
Connect-ExchangeOnline

# Import the CSV file containing the user data and email aliases
$csvPath = "C:\temp\biteuser1.csv" # Updated path to your CSV file location
$usersEmails = Import-Csv -Path $csvPath

foreach ($user in $usersEmails) {
    $userPrincipalName = $user.'user principal name'
    $displayName = $user.'display name'
    $aliasEmail1 = "smtp:" + $user.email1
    $aliasEmail2 = "smtp:" + $user.email2
    

    try {
        # Attempt to retrieve the mailbox based on UserPrincipalName
        $mailbox = Get-Mailbox -Identity $userPrincipalName -ErrorAction Stop
        $emailAddressesToAdd = @($aliasEmail1, $aliasEmail2)
        # Add each email alias to the user's mailbox
        Set-Mailbox -Identity $userPrincipalName -EmailAddresses @{add=$emailAddressesToAdd}
        Write-Host "Added email aliases for $displayName ($userPrincipalName)"
    } catch {
        try {
            # If Set-Mailbox fails, attempt to use Set-MailUser for unlicensed users
            Set-MailUser -Identity $userPrincipalName -EmailAddresses @{add=$emailAddressesToAdd}
            Write-Host "Added email aliases for unlicensed user $displayName ($userPrincipalName)"
        } catch {
            Write-Host "Error processing ${displayName} (${userPrincipalName}): $_"
        }
    }
}