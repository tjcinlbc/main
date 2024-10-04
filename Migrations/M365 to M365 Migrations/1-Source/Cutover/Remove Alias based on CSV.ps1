# Import the module to connect to Exchange Online
#Import-Module ExchangeOnlineManagement
#Add-WindowsFeature RSAT-AD-PowerShell
#Get-WindowsCapability -Online | Where-Object { $_.Name -like "Rsat.ActiveDirectory.DS-LDS.Tools*" } | Add-WindowsCapability -Online

#Import-Module ActiveDirectory
# Connect to Exchange Online
#Connect-ExchangeOnline

# Read the CSV file containing the user principal names (UPNs)
$upnList = Import-Csv -Path "C:\temp\users_8_2_2024 9_14_06 PM.csv"

# Loop through each user in the CSV
foreach ($user in $upnList) {
    # Retrieve all email addresses (aliases) for the user
    $emailAddresses = Get-Mailbox -Identity $user.'User principal name' | Select-Object -ExpandProperty EmailAddresses

    # Filter email addresses that match the old UPN
    $oldEmailAddresses = $emailAddresses | Where-Object { $_ -eq "smtp:" + $user.'old UPN' }

    # Remove the target email alias for the user
    foreach ($email in $oldEmailAddresses) {
        # Prepare the email address for removal
        $removeAddress = $email -replace "smtp:", ""
        # Update the mailbox
        Set-Mailbox -Identity $user.'User principal name' -EmailAddresses @{Remove=$removeAddress}
    }
}

# Disconnect from Exchange Online
#Disconnect-ExchangeOnline -Confirm:$false
