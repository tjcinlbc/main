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

            # Prepare the body for the PATCH request
            $body = @{
                proxyAddresses = $updatedProxyAddresses
            } | ConvertTo-Json

            # Send the PATCH request to update the user's proxyAddresses
            Invoke-MgGraphRequest -Method PATCH -Uri "https://graph.microsoft.com/v1.0/users/$($graphUser.Id)" -Body $body
            Write-Host "Added email aliases for $userPrincipalName"
        } else {
            Write-Host "No new aliases to add for $userPrincipalName"
        }
    } else {
        Write-Host "User with UPN '$userPrincipalName' not found."
    }
}