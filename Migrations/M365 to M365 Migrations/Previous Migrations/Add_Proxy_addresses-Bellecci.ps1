##Adds Alias to email accounts based on CSV file, need two columns titled Email and AliasEmail ##


# Install-Module -Name ExchangeOnlineManagement -Force
# Connect-ExchangeOnline

# Set-Mailbox -Identity "aarti.thacker@zempleo.com" -EmailAddresses @("SMTP:aarti.thacker@zempleo.com", "smtp:aarti.thacker@zempleoinc.onmicrosoft.com")

# Import the CSV file containing the user data and email aliases
$csvPath = "C:\Temp\Bellecci-users_new1.csv" # Updated path to your CSV file location
$usersEmails = Import-Csv -Path $csvPath

foreach ($user in $usersEmails) {
    $userPrincipalName = $user.UserPrincipalName
    $displayName = $user.DisplayName
    $email1 = $user.Email1
    $email2 = $user.Email2
    $email3 = $user.Email3
    $email4 = $user.Email4
    $email5 = $user.Email5
    $email6 = $user.Email6

    # Retrieve the mailbox based on UserPrincipalName
    $mailbox = Get-Mailbox -Identity $userPrincipalName

    # Check if the displayName matches
    if ($mailbox.DisplayName -eq $displayName) {
        # Add each email alias to the user
        Set-Mailbox -Identity $userPrincipalName -EmailAddresses @{add=$email1, $email2, $email3, $email4, $email5, $email6}
        Write-Host "Added email aliases for $userPrincipalName"
    } else {
        Write-Host "DisplayName does not match for $userPrincipalName. No aliases added."
    }
}