#Install-Module Microsoft.Graph  -Force -AllowClobber -Scope CurrentUser
#Install-Module Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber -Scope CurrentUser

#Import-Module Microsoft.Graph.Users
#Import-Module Microsoft.Online.SharePoint.PowerShell

Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All
Connect-SPOService -Url https://M365x91325595-admin.sharepoint.com

$Swap_DNS_Suffix = $true
$New_Domain = "M365x91325595.onmicrosoft.com"

$FileName = "users_9_13_2024 2_22_37 PM.csv"

$Folder = "$env:USERPROFILE\Downloads"
$File = $Folder + "\" + $FileName

# Check if the file exists, if not stop the script
if (-not (Test-Path $File)) {
    Write-Host "File not found: $File"
    exit
}


## Import users from CSV
$Userlist = Import-Csv -Path $File | foreach { 

    $UPN = $_."User principal name"
    # Change UPN to new domain
    if ($Swap_DNS_Suffix -eq $true) {
        $UPNParts = $UPN -split '@', 2
        $UPN = $UPNParts[0] + "@" + $New_Domain
    }
    $mailNickname = $UPNParts[0]

    # Change UPN case to lower
    $UPN = $UPN.ToLower()
    $mailNickname = $mailNickname.ToLower()

    $Data = [PSCustomObject]@{
        ## Required fields
        UPN = $UPN
        displayname = $_."Display name"
        givenName = $_."First Name"
        surname = $_."Last Name"
        mailNickname = $mailNickname
        
        usageLocation = "US"

        ## Optional fields
        company = "Corporate Concepts"
        department = $_."Department"
        jobTitle = $_."Title"
        office =$_."Office"
        streetAddress = $_."Street Address"
        city = $_."City"
        state = $_."State"
        postalCode = $_."Postal Code"
        country = $_."Country/Region"
        businessPhones = $_."Phone number"
        mobilePhone = $_."Mobile Phone"
        faxNumber = $_."Fax"
        preferredLanguage = $_."Preferred language"
        #preferredLanguage = "en-US"
        preferredDataLocation = $_."Preferred data location"
        licenses = $_."Licenses"
    }
    Write-Host $Data
    $Data
}

## Create users
foreach ($UPN in $Userlist) {

    # Skip user if the following fields are empty: UPN, displayname, mailNickname, usageLocation
    if (-not $UPN.UPN -or -not $UPN.displayname -or -not $UPN.mailNickname -or -not $UPN.usageLocation) {
        Write-Host "Skipping user: $($UPN.UPN)"
        # Determin which fields are missing
        if (-not $UPN.UPN) { Write-Host "UPN is missing" }
        if (-not $UPN.displayname) { Write-Host "displayname is missing" }
        if (-not $UPN.mailNickname) { Write-Host "mailNickname is missing" }
        if (-not $UPN.usageLocation) { Write-Host "usageLocation is missing" }
        continue
    }
    # Define a verified domain
$verifiedDomain = "M365x91325595.onmicrosoft.com"

# Ensure the UPN is constructed using the verified domain
$UPNPrefix = ($UPN.User -split '@', 2)[0]
$UPN = "$UPNPrefix@$verifiedDomain"

    $params = @{
        ## Required fields
        accountEnabled = $true
        userPrincipalName = $UPN.UPN
        displayName = $UPN.displayname
        mailNickname = $UPN.mailNickname
        usageLocation = $UPN.usageLocation
        passwordPolicies = "DisablePasswordExpiration"
        passwordProfile = @{
            password = 'Welc0me.123!'
            forceChangePasswordNextSignIn = $true
        }
    }

    ## Optional fields - Add only if they have values
    if ($UPN.givenName) { $params.givenName = $UPN.givenName }
    if ($UPN.surname) { $params.surname = $UPN.surname }
    if ($UPN.department) { $params.department = $UPN.department }
    if ($UPN.jobTitle) { $params.jobTitle = $UPN.jobTitle }
    if ($UPN.office) { $params.officeLocation = $UPN.office }
    if ($UPN.streetAddress) { $params.streetAddress = $UPN.streetAddress }
    if ($UPN.city) { $params.city = $UPN.city }
    if ($UPN.state) { $params.state = $UPN.state }
    if ($UPN.postalCode) { $params.postalCode = $UPN.postalCode }
    if ($UPN.country) { $params.country = $UPN.country }
    if ($UPN.businessPhones) { $params.businessPhones = $UPN.businessPhones }
    if ($UPN.mobilePhone) { $params.mobilePhone = $UPN.mobilePhone }
    if ($UPN.faxNumber) { $params.faxNumber = $UPN.faxNumber }
    if ($UPN.preferredLanguage) { $params.preferredLanguage = $UPN.preferredLanguage }
    if ($UPN.preferredDataLocation) { $params.preferredDataLocation = $UPN.preferredDataLocation }

    # Write-Host ($params | Out-String)

    New-MgUser -BodyParameter $params
}




