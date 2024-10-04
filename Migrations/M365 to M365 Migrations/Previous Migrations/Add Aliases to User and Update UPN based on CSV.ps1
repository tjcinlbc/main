Install-Module -Name ExchangeOnlineManagement -Force
Connect-ExchangeOnline

# Import the CSV file containing the user data and email aliases
$csvPath = "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Interior Investments\20240812 - 365 Migration\usersMasterCorpConc.csv" # Updated path to your CSV file location
$usersEmails = Import-Csv -Path $csvPath

foreach ($user in $usersEmails) {
    $userPrincipalName = $user.'user principal name'
    $displayName = $user.'display name'
    $newUPN = $user.newUPN
    $emailAddressesToAdd = $user.'email aliases' -split ';' # Assuming email aliases are separated by semicolons in the CSV

    try {
        $mailbox = Get-Mailbox -Identity $userPrincipalName -ErrorAction Stop

        # Ensure $emailAddressesToAdd is an array and remove any null or empty values
        $emailAddressesToAdd = $emailAddressesToAdd | Where-Object { $_ -ne $null -and $_ -ne '' }
        
        # Add each email alias to the user's mailbox
        Set-Mailbox -Identity $userPrincipalName -EmailAddresses @{add=$emailAddressesToAdd}

        # Check if newUPN is provided and different from the current UPN
        if ($newUPN -and $newUPN -ne $userPrincipalName) {
            # Update the user's UPN to newUPN
            Set-Mailbox -Identity $userPrincipalName -UserPrincipalName $newUPN
            Write-Host "Updated UPN and added email aliases for $displayName ($newUPN)"
        } else {
            Write-Host "Added email aliases for $displayName ($userPrincipalName)"
        }
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
