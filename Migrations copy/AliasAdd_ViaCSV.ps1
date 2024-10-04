# First, connect to Exchange Online
Connect-ExchangeOnline

# Specify the path to your CSV file
$csvPath = "C:\Users\ZachThomas\Downloads\Fly_Gmail_Project_Mappings_Google _ M365 Mail_20240718220542.csv"

# Read the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV
foreach ($user in $users) {
    # Extract UPN and the new alias
    $upn = $user.NewEmail
    $newAlias = $user.Source

    # Retrieve the current email addresses
    $mailbox = Get-EXOMailbox -Identity $upn
    $currentEmailAddresses = $mailbox.EmailAddresses

    # Add the new alias
    $newEmailAddresses = $currentEmailAddresses + "smtp:$newAlias"

    # Update the mailbox
    Set-Mailbox -Identity $upn -EmailAddresses $newEmailAddresses

    Write-Host "Added alias $newAlias to $upn"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
