#Install-Module Microsoft.Graph -Scope CurrentUser
Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

$Userlist = Import-Csv -Path "C:\temp\users_7_9_2024 5_51_44 PM.csv" | foreach { 
    $Data = [PSCustomObject]@{
        displayname = $_."Display name"
        City = $_.City
        Country = $_."Country/Region"
        department = $_.Department
        jobTitle = $_.Title
        UPN = $_."User principal name"
        givenName = $_."First Name"
        surname = $_."Last Name"
    }
    $Data
}

foreach ($User in $Userlist) {
    $UPN = $User.UPN
    $ExistingUser = Get-MgUser -Filter "userPrincipalName eq '$UPN'"

    if ($ExistingUser) {
        Write-Host "User with UPN '$UPN' already exists. Skipping creation."
    }
    else {
        $params = @{
            accountEnabled = $true
            displayName = $User.Displayname
            givenName = $User.givenName
            mailNickname = $User.givenName
            passwordPolicies = "DisablePasswordExpiration"
            passwordProfile = @{
                password = 'Welcome123!'
                forceChangePasswordNextSignIn = $true
            }
            surname = $User.surname
            userPrincipalName = $User.UPN
        }
        Write-Host "Creating user with UPN '$UPN'"
        New-MgUser -BodyParameter $params
    }
}

Get-MgUser
