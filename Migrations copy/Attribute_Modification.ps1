Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All, Directory.AccessAsUser.All


$Data = @()

$CSV = Import-Csv -Path "C:\Users\ZachThomas\Trusted Tech Team, Irvine\ProServices - Delivery - Documents\Clients\Vetcor\YouVetDoc_Users.csv"
$UserList = $CSV

<#
$Userlist = Import-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\Cat_GuestUser_Update.csv" | foreach { 
    #$Display = $_."Payroll Name"
    #$Parts = $Display -split ',', 2
    #$UPNParts = $_.userPrincipalName -split '@', 2
    #$First = $Parts[1].Trim()
    #$PartsF = $First -split ' ', 2
    #$FirstName = $PartsF[0].Trim()
    #$LastName = $Parts[0].Trim()
    #$FI = $FirstName.Substring(0,1)

    #$DisplayName = $FirstName + " " + $LastName
    $Displayname = $_.Displayname
    $Firstname = $_.givenName
    $LastName = $_.surname
    

    #$UID = (Get-MGUser -Filter "displayName eq '$DisplayName'").Id
    #$UPN = (Get-MGUser -Filter "displayName eq '$DisplayName'").userPrincipalName
    $UPN = $_.userPrincipalName
    $UID = (Get-MGUser -Filter "userPrincipalName eq '$UPN'").Id

    <#
    $Sup = $_."Supervisor"
    $Supervisor = $Sup -replace '(\w+), (\w+) .+', '$2 $1'

    $SUPN = (Get-MGUser -Filter "displayName eq '$Supervisor'").userPrincipalName
    $SUID = (Get-MGUser -Filter "displayName eq '$Supervisor'").Id
    

    #$UPN = $UPNParts[0] + "@angstrom-usa.com"
    $Data = [PSCustomObject]@{
        displayname = $DisplayName
        #City = $_.City
        #Country = $_."Country/Region"
        department = $_.department
        #jobTitle = $_.Title
        UPN = $UPN
        UID = $UID
        givenName = $FirstName
        surname = $LastName
        #office =$_.Market
        #supervisor = $Supervisor
        #SUPN = $SUPN
        #SUID = $SUID
        Company = $_.CompanyName
        #OLDUPN = $_.userPrincipalName
        #Licensing = $_.Licensing
    }
    $Data
}
#>

$UserList | ForEach-Object {
    $UPN = $_."SASS UPN"
    #$New = $_.Source
    #$Sup = $_.Manager
    #Write-Host $SUP
    $Pass = $_."Temp"
    $params = @{
	    #accountEnabled = $true
        #city = $UPN.City
        #country = $UPN.Country
        #department = $_.department
        #displayName = $_.Displayname
        #jobTitle = $_.Title
        #companyName = $UPN.Company
        #givenName = $_.firstname
        #mailNickname = $UPN.givenName
        #passwordPolicies = "DisablePasswordExpiration"
        passwordProfile = @{
            password = $($Pass)
            forceChangePasswordNextSignIn = $true
        }
        #officeLocation = $_.office
        #postalCode = "98052"
        #preferredLanguage = "en-US"
        #state = "WA"
        #streetAddress = "9256 Towne Center Dr., Suite 400"
        #surname = $_.lastname
        #mobilePhone = "+1 206 555 0110"
        #usageLocation = "US"
        #userPrincipalName = $New
    }
    $ID = (Get-MgUser -UserId $UPN).Id
    Update-MgUser -UserId $ID -BodyParameter $params
    <#$SID = (Get-MgUser -Filter "displayName eq '$SUP'").Id
    $NewManager = @{
        "@odata.id"="https://graph.microsoft.com/v1.0/users/$SID"
        }
    Set-MgUserManagerByRef -UserId $ID -BodyParameter $NewManager#>
}

$Man = $UserList | ForEach-Object {
    $UPN = $_.Email
    $ID = (Get-MgUser -UserId $UPN).Id
    $Manager = $ID = Get-MgUserManager -UserId $ID
    $Data = [PSCustomObject]@{
        UPN = $UPN
        Manager = $Manager
    }
    $Data
}



$Userlist | Export-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\Hakes_RevisedList.csv" -NoTypeInformation

$NewManager = @{
    "@odata.id"="https://graph.microsoft.com/v1.0/users/075b32dd-edb7-47cf-89ef-f3f733683a3f"
    }
  
  Set-MgUserManagerByRef -UserId '8a7c50d3-fcbd-4727-a889-8ab232dfea01' -BodyParameter $NewManager