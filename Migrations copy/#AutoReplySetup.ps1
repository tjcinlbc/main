#AutoReplySetup

Connect-ExchangeOnline

$csvPath = "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\Angtrom_Users_Listing.csv"

$usersToForward = Import-Csv -Path $csvPath

foreach ($user in $usersToForward) {
    $PKOH = $user.OLDUPN
    $ANG = $user.UPN
    $Message = "Dear Sender

    Be advised that your email is automatically forwarded to $($ANG). The person you have sent email to, has a new email address $($ANG). Please update your contact information.
    
    All emails sent to $($PKOH) will no longer be valid or delivered after 04/30/2024.
    
    Thank you."
    Set-MailboxAutoReplyConfiguration -identity $ANG -autoreplystate disabled
}