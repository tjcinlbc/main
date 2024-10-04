#Adds Alias to email accounts based on CSV file, need two columns titled Email and AliasEmail ##


# Install-Module -Name ExchangeOnlineManagement -Force
# Connect-ExchangeOnline

# Set-Mailbox -Identity "aarti.thacker@zempleo.com" -EmailAddresses @("SMTP:aarti.thacker@zempleo.com", "smtp:aarti.thacker@zempleoinc.onmicrosoft.com")

# Import the CSV file containing the user data and email aliases
$csvPath = "C:\Temp\Coleman-users_new1.csv" # Updated path to your CSV file location
$usersEmails = Import-Csv -Path $csvPath

function Add-EmailAliases {
    param (
        [string]$principalName,
        [string[]]$emailAliases
    )
    try {
        # Attempt to retrieve the mailbox based on principalName
        $mailbox = Get-Mailbox -Identity $principalName -ErrorAction Stop
    
        # Retrieve current email addresses
        $currentEmailAddresses = $mailbox.EmailAddresses.SmtpAddress
    
        # Check for a match
        $matchFound = $emailAliases | Where-Object { $currentEmailAddresses -contains $_ }
    
        # If a match is found, add all the aliases
        if ($matchFound) {
            Set-Mailbox -Identity $principalName -EmailAddresses @{add=$emailAliases}
            Write-Output "Added email aliases for $principalName because a matching alias was found."
            return $true
        } else {
            Write-Output "No matching alias found for $principalName. No aliases added."
            return $false
        }
    } catch {
        Write-Output "$principalName does not exist."
        return $false
    }
}

foreach ($user in $usersEmails) {
    $emailAliases = @($user.Email1, $user.Email2, $user.Email3, $user.Email4, $user.Email5, $user.Email6)
    $principalNames = @($user.UserPrincipalName, $user.UserPrincipalName, $user.UserPrincipalName2, $user.UserPrincipalName3)

    foreach ($principalName in $principalNames) {
        if ($principalName -and (Add-EmailAliases -principalName $principalName -emailAliases $emailAliases)) {
            break # Exit the loop if aliases were successfully added
        }
    }
}