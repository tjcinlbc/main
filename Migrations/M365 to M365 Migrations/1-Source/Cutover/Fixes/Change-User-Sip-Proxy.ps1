Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name MicrosoftTeams -Force -AllowClobber
Import-Module MicrosoftTeams

Install-Module MSOnline -Force
import-module msonline

Connect-MsolService
Connect-AzureAD
Connect-MicrosoftTeams

##########################################
### target user requires teams license ###
##########################################

$user = "netadmin-migrated@mountaineerpro.onmicrosoft.com"

Get-AzureADUser -ObjectId $user | Format-List 

Get-CsOnlineUser $user | fl userprincipalname, sipaddress, sipproxyaddress, email, proxyaddresses, windowsemailaddress, interpretedusertype, mcovalidationerror
# Clear the attribute for a specific user
Set-Mailbox -Identity $user -EmailAddresses @{remove="sip:503d22c1bb964200b97ee45e1e2cc73bnetadmin@mountaineer.pro"}
Set-Mailbox -Identity $user -EmailAddresses @{remove="SIP:503d22c1bb964200b97ee45e1e2cc73bnetadmin@mountaineer.pro"}
