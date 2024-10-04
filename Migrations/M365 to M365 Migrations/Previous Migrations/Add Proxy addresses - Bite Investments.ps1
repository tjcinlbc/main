##Adds Alias to email accounts based on CSV file, need two columns titled Email, AliasEmail1, and AliasEmail2 ##
Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import the CSV file containing the user data and email aliases
$csvPath = "C:\temp\biteuser1.csv" # Update this path to your CSV file location
$usersEmails = Import-Csv -Path $csvPath

foreach ($user in $usersEmails) {
    $userPrincipalName = $user.Email
    $aliasEmail1 = "smtp:" + $user.AliasEmail1
    $aliasEmail2 = "smtp:" + $user.AliasEmail2

    # Retrieve the user by their UPN
    $graphUser = Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'"

    if ($graphUser) {
        # Prepare the email addresses to add, ensuring not to duplicate existing entries
        $existingProxyAddresses = $graphUser.ProxyAddresses
        $newProxyAddresses = @($aliasEmail1, $aliasEmail2) | Where-Object { $_ -notin $existingProxyAddresses }

        if ($newProxyAddresses.Count -gt 0) {
            # Combine existing and new proxy addresses
            $updatedProxyAddresses = $existingProxyAddresses + $newProxyAddresses

            # Update the user's proxyAddresses
            Update-MgUser -UserId $graphUser.Id -ProxyAddresses $updatedProxyAddresses
            Write-Host "Added email aliases for $userPrincipalName"
        } else {
            Write-Host "No new aliases to add for $userPrincipalName"
        }
    } else {
        Write-Host "User with UPN '$userPrincipalName' not found."
    }
}