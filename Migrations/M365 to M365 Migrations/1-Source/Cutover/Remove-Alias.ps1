# Import the module to connect to Exchange Online
#Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Read the CSV file containing the user principal names (UPNs)
$upnList = Import-Csv -Path "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Interior Investments\20240812 - 365 Migration\usersMasterInterior.csv"

# Loop through each UPN in the CSV
foreach ($user in $upnList) {
    # Retrieve all email addresses (aliases) for the user
    $emailAddresses = Get-Mailbox -Identity $user.onUPN | Select-Object -ExpandProperty EmailAddresses

    # Filter email addresses that end with target domain
    $oldEmailAddresses = $emailAddresses | Where-Object { $_ -like "*@interiorinvestments.com," }

    # Remove the targe email aliases for the user
    foreach ($email in $oldEmailAddresses) {
        # Prepare the email address for removal
        $removeAddress = $email -replace "smtp:", ""
        # Update the mailbox
        Set-Mailbox -Identity $user.NewUPN -EmailAddresses @{Remove=$removeAddress}
    }
}

# Disconnect from Exchange Online
#Disconnect-ExchangeOnline -Confirm:$false
