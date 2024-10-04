#Create Shared Mailboxes from CSV

Connect-ExchangeOnline

$Data = @()

$SharedList = Import-Csv -Path "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Payhawk\20240611 - 365 Migration\payhawksharedmailboxes.csv" | foreach {
    $EmailParts = $_.PrimarySMTPAddress -split "@"
    $SharedMailBox = $EmailParts[0] + "@gopayhawk.com"
    $Data = [PSCustomObject]@{
        OldAddress = $_.PrimarySMTPAddress
        DisplayName = $_.DisplayName
        NewAddress = $SharedMailBox
        Alias = $EmailParts[0]
    }
    $Data
}

$SharedList | Export-Csv -Path ""C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Payhawk\20240611 - 365 Migration\payhawksharedmailboxesexport.csv"" -NoTypeInformation

foreach ($Item in $SharedList){
    New-MailBox -Shared -Name $Item.DisplayName -PrimarySMTPAddress $Item.NewAddress -Alias $Item.Alias -DisplayName $Item.DisplayName
}

