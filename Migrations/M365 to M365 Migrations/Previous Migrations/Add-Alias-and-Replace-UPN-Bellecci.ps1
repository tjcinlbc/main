# Does not fully work, it doesn't remove the email alais and it doesn't skip external users

# Install-Module -Name AzureAD -Force -AllowClobber -Scope CurrentUser
# Install-Module -Name ExchangeOnlineManagement -Force

# Connect-ExchangeOnline
# Connect-AzureAD


# Define the path to the CSV file
$csvPath = "C:\Temp\users_master.csv"

# Domains to remove from proxy addresses comma-separated
#$domainsToRemove = "contoso.com,contoso.io,contoso.net"
$domainsToRemove = "bellecci.com"
# onmicrosoft.com domain
#$onmicrosoftDomain = "contoso.onmicrosoft.com"
$onmicrosoftDomain = "bellecci.onmicrosoft.com"

# Read the CSV file and process each user
Import-Csv -Path $csvPath | ForEach-Object {
    $upn = $_."User principal name"
    $proxyAddresses = $_."Proxy addresses" -split ';'
    $username = $upn.Split("@")[0]
    $newUpn = "$username-migrated@$onmicrosoftDomain"

    # Find current primary SMTP address
    #$currentPrimarySmtp = $proxyAddresses | Where-Object { $_ -match '^SMTP:' }
    # Construct the command to update proxy addresses in Exchange Online
    $primarySmtp = "SMTP:$newUpn"
    # Remove the existing primary SMTP prefix and add the new primary
    $smtpAddresses = $proxyAddresses | Where-Object { $_ -notmatch '^SMTP:' }
    $smtpAddresses += $primarySmtp

    # Using the $domainsToRemove remove any proxy addresses that contain the domain
    $smtpAddresses = $smtpAddresses | Where-Object { $address = $_; $domainsToRemove -notcontains ($address -split ":")[1].Split("@")[1] }
    
    # Update the mailbox in Exchange Online
    Set-Mailbox -Identity $upn -EmailAddresses $smtpAddresses -WindowsEmailAddress $newUpn

    # Update the UPN in Azure AD
    Set-AzureADUser -ObjectId $upn -UserPrincipalName $newUpn

    # Upddate the UPN in Exchange Online
    Set-Mailbox -Identity $newUpn -EmailAddresses $smtpAddresses -WindowsEmailAddress $newUpn

    # Output the results to CSV with the new UPN and the old UPN
    [PSCustomObject]@{
        OldUPN = $upn
        NewUPN = $newUpn
    } | Export-Csv -Path "C:\Temp\upn_updates.csv" -NoTypeInformation -Append

    # Output the result
    Write-Host "Updated mailbox for $upn with new UPN $newUpn."
}

# Disconnect from Exchange Online if desired
#Disconnect-ExchangeOnline -Confirm:$false
