Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All
Connect-MsolService
Connect-ExchangeOnline

$UserPath = "C:\Users\ZachThomas\Downloads\PKOH_Users_With_IDandLicensing.csv"
$UserList = Import-Csv -Path $UserPath

foreach ($User in $UserList) {
    Restore-MsolUser -UserPrincipalName $($User.UPN)
}

foreach ($User in $UserList) {
    $UPN = $User.UPN
    $UID = (Get-MgUser -Filter "userPrincipalName eq '$UPN'").Id
    $License = $User.License
    $LP = $License -split ', '
    foreach ($L in $LP) {
        Set-MgUserLicense -UserId $UID -AddLicenses @{SKUID = $L} -RemoveLicenses @()
    }
}

foreach ($User in $UserList) {
    try {        
        Set-Mailbox -Identity $($User.UPN) -Type Shared
    }
    catch {
        Write-Host "Failed to convert $($User.UPN) to a shared mailbox"
    }
}

$Status = foreach ($User in $UserList) {      
    $Type = (Get-Mailbox -Identity $($User.UPN)).RecipientTypeDetails
    $Type2 = (Get-Mailbox -Identity $($User.UPN)).RecipientType
    $Data = [PSCustomObject]@{
        UPN = $User.UPN
        Type = $Type
        Type2 = $Type2
    }
    $Data
}

foreach ($UPN in $Userlist) {
    $params = @{
	    accountEnabled = $False
    }
    Update-MgUser -UserId $UID -BodyParameter $params
}

$Status | Export-Csv -Path "C:\Users\ZachThomas\Downloads\PKOHShared_Status.csv" -NoTypeInformation

foreach ($User in $UserList) {
    $UPN = $User.UPN
    $UID = (Get-MgUser -Filter "userPrincipalName eq '$UPN'").Id
    $License = @()
    $License += (Get-MgUserLicenseDetail -UserId $UID).SkuId
    Set-MgUserLicense -UserId "$UID" -AddLicenses @{} -RemoveLicenses $License
}


$UserID = foreach ($User in $UserList) {
    $UPN = $null
    $UID = $null
    $Display = $User.displayName
    $UPN = $User.UPN
    $UID = $User.ID
    #$UID = (Get-MgUser -Filter "startsWith(displayname, '$($Display)')").Id
    #$UPN = (Get-MgUser -UserId $UID).userPrincipalName
    #$UPN = $UPN -join ", "
    $License = @()
    $License += (Get-MgUserLicenseDetail -UserId $UID).SkuId
    $License = $License -join ", "
    $Data = [pscustomobject]@{
        DisplayName = $Display
        UPN = $UPN
        ID = $UID
        License = $License
    }
    $Data
}

$UserID | Export-Csv -Path "C:\Users\ZachThomas\Downloads\PKOH_Users_With_IDandLicensing_Update.csv" -NoTypeInformation
