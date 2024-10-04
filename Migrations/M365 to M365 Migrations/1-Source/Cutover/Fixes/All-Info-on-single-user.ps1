# Connect-AzureAD
# Connect-ExchangeOnline

$user = "netadmin-migrated@mountaineerpro.onmicrosoft.com"
Get-AzureADUser -ObjectId $user | Format-List *
Get-Mailbox -Identity $user | Format-List *
Get-Mailbox -Identity $user | Select-Object -ExpandProperty EmailAddresses
