# Import the Active Directory module
Import-Module ActiveDirectory

# Set the working directory
$workDir = "C:\Temp"
$o365UserFile = "$workDir\users_5_22_2024.csv"
$matchesFile = "$workDir\upn.csv"
$Password = "B3ll3cci!!"

# Load O365 users and matches from CSV
$o365Users = Import-Csv -Path $o365UserFile
$matches = Import-Csv -Path $matchesFile

# Iterate through each match in Matches.csv
foreach ($match in $matches) {
    $adSamAccountName = $match.displayName
    $o365UserPrincipalName = $match.O365_displayName
    $OU = $match.OU

    # Find the corresponding O365 user details from the O365 users file
    $o365User = $o365Users | Where-Object { $_."User principal name" -eq $o365UserPrincipalName }

    if ($o365User) {
        try {
            New-ADuser -Identity $adUser -Path $OU -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $true -PassThru
            # Retrieve AD User by sAMAccountName
            $adUser = Get-ADUser -Identity $adSamAccountName -Properties *

            if ($adUser) {
                $updates = @{}

                # Handle proxyAddresses separately to ensure proper formatting
                $proxyAddresses = $o365User."Proxy addresses" -split '\+'
                $formattedAddresses = @($proxyAddresses | ForEach-Object { $_.Trim() })

                if ($formattedAddresses) {
                    $updates['proxyAddresses'] = $formattedAddresses
                }

                # Primary SMTP for mail attribute
                $primarySmtp = ($formattedAddresses | Where-Object { $_ -cmatch '^SMTP:' }) -replace 'SMTP:', ''

                if ($primarySmtp) {
                    $updates['mail'] = $primarySmtp
                    $upnSuffix = $primarySmtp.Split('@')[1]
                    $upnPrefix = $adUser.UserPrincipalName.Split('@')[0]
                    $newUpn = "$upnPrefix@$upnSuffix"
                    $updates['UserPrincipalName'] = $newUpn
                }

                # Additional attributes to update if not blank
                $attributes = @{
                    'City' = 'City'; 'Country/Region' = 'Country'; 'Department' = 'Department'; 
                    'Display name' = 'displayName'; 'Fax' = 'Fax'; 'First name' = 'GivenName'; 
                    'Last name' = 'sn'; 'Mobile Phone' = 'Mobile'; 'Office' = 'PhysicalDeliveryOfficeName'; 
                    'Phone number' = 'TelephoneNumber'; 'Postal code' = 'PostalCode'; 
                    'State' = 'State'; 'Street address' = 'StreetAddress'; 'Title' = 'Title'
                }

                # Loop through each additional attribute and add to updates if not blank
                foreach ($key in $attributes.Keys) {
                    if ($o365User.$key -and $o365User.$key.Trim() -ne '') {
                        $updates[$attributes[$key]] = $o365User.$key
                    }
                }

                # Perform update if updates dictionary is not empty
                if ($updates.Count -gt 0) {
                    Set-ADUser -Identity $adUser -Replace $updates
                    Write-Host "Updated AD user: $($adUser.SamAccountName) with attributes: $($updates.Keys -join ', ')"
                } else {
                    Write-Host "No attributes to update for AD user: $($adUser.SamAccountName)"
                }
            } else {
                Write-Host "No AD user found for sAMAccountName: $adSamAccountName"
            }
        } catch {
            Write-Host "Error updating AD user: $_"
        }
    } else {
        Write-Host "No corresponding O365 user found for UserPrincipalName: $o365UserPrincipalName"
    }
}

Write-Host "Update process completed."
