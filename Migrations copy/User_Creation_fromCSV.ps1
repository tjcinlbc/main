Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

<#
Needed Columns:
DisplayName
Email\UPN
Licensing
useageLocation (if not in US)
password (if wanted my client)

Prefered Columns (in addition to above)
Job Title
Manager
Office Location
Department
Company
#>

$Userlist = Import-Csv -Path "C:\Users\JimCosner\Downloads\users_7_22_2024 9_32_17 PM.csv" | foreach { 
    #$Name = $_.Name
    #$Parts = $Name -split ', ', 2
    #$UPNParts = $_.userPrincipalName -split '@', 2
    #$FirstName = $Parts[1].Trim()
    #$FirstParts = $FirstName -split ' ', 2
    #$First = $FirstParts[0].Trim()
    #$LastName = $Parts[0].Trim()
    #$LastParts = $LastName -split ' ', 2
    #$Last = $LastParts[0].Trim()
    #$FI = $FirstName.Substring(0,1)
    #$UPNPrefix = $FI + $Last
    #$DisplayName = $FirstName + " " + $LastName

    $DisplayName = $_.Displayname
    $UPN = $_.Email
    $UPNParts = $UPN -split '@', 2
    $UPNPrefix = $UPNParts[0]

    $Data = [PSCustomObject]@{
        displayname = $DisplayName
        City = $_.City
        Country = $_.Country
        mailName = $UPNPrefix
        department = $_.department
        jobTitle = $_.jobTitle
        UPN = $UPN
        givenName = $_.givenName
        surname = $_.surname
        office =$_.officeLocation
        #OLDUPN = $_.Email
        Licensing = $_.License
        #Company = "TurfDoctor"
        StreetAddress = $_.StreetAddress
        PostalCode = $_.PostalCode
        State = $_.State
    }
    $Data
}

#$Userlist | Export-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\Senske\TurfDoc_Upload_Checklist.csv" -NoTypeInformation

<#
REQUIRED PARAMS:
accountEnabled
displayName
passwordPolicy
passwordProfile
usageLocation
userPrincipalName
#>

foreach ($UPN in $Userlist) {
    $params = @{
	    accountEnabled = $true
        city = $UPN.City
        country = $UPN.Country
        department = $UPN.department
        displayName = $UPN.Displayname
        jobTitle = $UPN.jobTitle
        #companyName = $UPN.Company
        givenName = $UPN.givenName
        mailNickname = $UPN.mailName
        passwordPolicies = "DisablePasswordExpiration"
        passwordProfile = @{
            password = 'Welcome123!'
            forceChangePasswordNextSignIn = $true
        }
        officeLocation = $UPN.office
        postalCode = $UPN.PostalCode
        #preferredLanguage = "en-US"
        state = $UPN.State
        streetAddress = $upn.StreetAddress
        surname = $UPN.surname
        #mobilePhone = "+1 206 555 0110"
        usageLocation = ""US
        userPrincipalName = $UPN.UPN
    }
        New-MgUser -BodyParameter $params
        start-sleep -seconds 15
        #Updating manager
        <#$ID = (Get-MgUser -UserId $UPN.UPN).Id
        $SID = (Get-MgUser -Filter "displayName eq '$SUP'").Id
        $NewManager = @{
            "@odata.id"="https://graph.microsoft.com/v1.0/users/$SID"
            }
        Set-MgUserManagerByRef -UserId $ID -BodyParameter $NewManager#>
}

$O365E3 = "6fd2c87f-b296-42f0-b197-1e91e994b900"
$O365E5 = "c7df2760-2c81-4ef7-b578-5b5392b571df"
$M365E3 = "05e9a617-0261-4cee-bb44-138d3ef5d965"
$M365E5 = "78e66a63-337a-4a9a-8959-41c6654dfb56"
$M365F3 = "c68f8d98-5534-41c8-bf36-22fa496fa792"
$M365F1 = "c5928f49-12ba-48f7-ada3-0d743a3601d5"
$BusinessBasic = "3b555118-da6a-4418-894f-7df1e2096870"
$businessPremium = "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46"

foreach ($User in $UserList) {
    if ($user.licensing -eq "E3"){
        Set-MgUserLicense -UserId $User.UPN -AddLicenses @{SkuId = $M365E3} -RemoveLicenses @()
    }
    elseif ($user.licensing -eq "Business Premium"){
        Set-MgUserLicense -UserId $User.UPN -AddLicenses @{SkuId = $businessPremium} -RemoveLicenses @()
    }
}

