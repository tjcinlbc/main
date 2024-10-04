# Install-Module Microsoft.Graph -Scope CurrentUser -AllowClobber -Force
# Import-Module Microsoft.Graph.Users
# Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

$Userlist = Import-Csv -Path "C:\temp\users_AllMigrated_PreMedica.csv" | foreach {
    $Data = [PSCustomObject]@{
        displayName = $_."Display name"
        City = $_.City
        Country = $_."Country/Region"
        department = $_.Department
        jobTitle = $_.Title
        UPN = $_."New Tenant MS UPN"
        newUPN = $_."Original Tenant UPN" # Assuming there's a "new UPN" column in the CSV
        givenName = $_."First Name"
        surname = $_."Last Name"
    }
    $Data
}

foreach ($User in $Userlist) {
    $UPN = $User.UPN
    $newUPN = $User.newUPN
    $ExistingUser = Get-MgUser -Filter "userPrincipalName eq '$UPN'"

    if ($ExistingUser) {
        try {
            # Update the user's UPN
            Update-MgUser -UserId $UPN -UserPrincipalName $newUPN
            Write-Host "Successfully updated user: $UPN to new UPN: $newUPN"
        } catch {
            Write-Host "Error updating user: $UPN. Error: $_"
        }
    } else {
        Write-Host "User with UPN '$UPN' does not exist. Skipping."
    }
}