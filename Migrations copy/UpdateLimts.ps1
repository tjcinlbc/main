Connect-ExchangeOnline

$Users = Import-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\MDTeam\MD_Office365 Migration Licenses.csv"

$Users | foreach {
    $UPN = $_.userPrincipalName
    Set-Mailbox -Identity $UPN -MaxSendSize 153600kb -MaxReceiveSize 153600kb
}