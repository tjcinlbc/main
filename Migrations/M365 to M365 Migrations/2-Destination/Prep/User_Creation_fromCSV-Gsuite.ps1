#Install-Module Microsoft.Graph -Scope CurrentUser

Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

$Userlist = Import-Csv -Path "C:\Users\JimCosner\Nextcloud\Development\Migrations\Google-User_Download_14112023_214142.csv" | foreach { 
    $Data = [PSCustomObject]@{
        #City = $_.City
        Country = $_."Country/Region"
        department = $_."Department"
        jobTitle = $_."Employee Title"
        UPN = $_."Email Address [Required]"
        givenName = $_."First Name [Required]"
        surname = $_."Last Name [Required]"
        status = $_."Status [READ ONLY]"
    }
    $Data
}

foreach ($UPN in $Userlist) {

    if ($UPN.status -ne "Active") {
        Write-Host "Skipping user creation for $($UPN.UPN) due to inactive status."
        continue
    }

    $params = @{
	    accountEnabled = $true
        #city = $UPN.City
        #country = $UPN.Country
        #department = $UPN.department
        displayName = $UPN.givenName + " " + $UPN.surname
        #jobTitle = $UPN.jobTitle
        givenName = $UPN.givenName
        mailNickname = $UPN.givenName
        passwordPolicies = "DisablePasswordExpiration"
        passwordProfile = @{
            password = 'Welcome123!'
            forceChangePasswordNextSignIn = $true
        }
        #officeLocation = "131/1105"
        #postalCode = "98052"
        #preferredLanguage = "en-US"
        #state = "WA"
        #streetAddress = "9256 Towne Center Dr., Suite 400"
        surname = $UPN.surname
        #mobilePhone = "+1 206 555 0110"
        #usageLocation = "US"
        userPrincipalName = $UPN.UPN
    }
    Write-Host $params
    New-MgUser -BodyParameter $params
}

Get-MgUser