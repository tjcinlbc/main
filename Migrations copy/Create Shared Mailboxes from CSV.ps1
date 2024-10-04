#Create Shared Mailboxes from CSV

Connect-ExchangeOnline

$Data = @()

$SharedList = Import-Csv -Path "C:\Users\ZachThomas\Trusted Tech Team, Irvine\ProServices - Delivery - Documents\Clients\Vetcor\Shared_Distribution Groups - Shared Mailboxes.csv" | foreach {
    $EmailParts = $_.Mailboxes -split "@"
    $DisplayName = $EmailParts[0]
    $Data = [PSCustomObject]@{
        Address = $_.Mailboxes
        DisplayName = $DisplayName
    }
    $Data
}

$SharedList | Export-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\Shared_Mailboxes_Final.csv" -NoTypeInformation

foreach ($Item in $SharedList){
    New-MailBox -Shared -Name $Item.DisplayName -PrimarySMTPAddress $Item.Address
}

