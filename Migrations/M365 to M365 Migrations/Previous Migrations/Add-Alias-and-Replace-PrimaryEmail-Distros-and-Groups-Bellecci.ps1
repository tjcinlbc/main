# Main script starts here
#Connect-ExchangeOnline

# Path to the CSV file
$csvPath = "C:\Temp\Groups.csv"

# Reading the CSV file
$groups = Import-Csv -Path $csvPath

foreach ($group in $groups) {
    $primaryEmail = $group."Group primary email"
    $localPart = $primaryEmail.Split('@')[0]
    $newPrimaryEmail = "$($localPart)-bellecci.onmicrosoft.com"
    
    # Generate the new primary SMTP address and keep the old primary as an alias
    $newEmailAddresses = @("SMTP:$newPrimaryEmail", "smtp:$primaryEmail")

    # Adding the new primary email address and setting the old primary as an alias
    try {
        # Update the email addresses for the group
        Set-UnifiedGroup -Identity $primaryEmail -EmailAddresses $newEmailAddresses
        Set-UnifiedGroup -Identity $primaryEmail -PrimarySmtpAddress $newPrimaryEmail
        # remove the old primary email address
        Set-UnifiedGroup -Identity $newPrimaryEmail -EmailAddresses @{Remove="smtp:$primaryEmail"}
        Write-Host "Successfully updated primary address to $newPrimaryEmail for group $primaryEmail"
        # Add the old and new to a csv in c:\Temp\Groups-Changed.csv append and don't replace
        [PSCustomObject]@{
            OldPrimaryEmail = $primaryEmail
            NewPrimaryEmail = $newPrimaryEmail
        } | Export-Csv -Path "C:\Temp\Groups-Changed.csv" -NoTypeInformation -Append
    } catch {
        Write-Host "Failed to update primary address for $primaryEmail. Error: $_"
    }
}
# Handling distribution groups
$distroGroups = Import-Csv -Path $csvPath

foreach ($distroGroup in $distroGroups) {
    $primaryEmail = $distroGroup."Group primary email"
    $localPart = $primaryEmail.Split('@')[0]
    $newPrimaryEmail = "$($localPart)-bellecci.onmicrosoft.com"
    
    # Generate the new primary SMTP address and keep the old primary as an alias
    $newEmailAddresses = @("SMTP:$newPrimaryEmail", "smtp:$primaryEmail")

    # Adding the new primary email address and setting the old primary as an alias
    try {
        # Update the email addresses for the distribution group
        Set-DistributionGroup -Identity $primaryEmail -EmailAddresses $newEmailAddresses
        Set-DistributionGroup -Identity $primaryEmail -PrimarySmtpAddress $newPrimaryEmail
        # remove the old primary email address
        Set-DistributionGroup -Identity $newPrimaryEmail -EmailAddresses @{Remove="smtp:$primaryEmail"}
        Write-Host "Successfully updated primary address to $newPrimaryEmail for distribution group $primaryEmail"
        # Add the old and new to a csv in c:\Temp\Groups-Changed.csv append and don't replace
        [PSCustomObject]@{
            OldPrimaryEmail = $primaryEmail
            NewPrimaryEmail = $newPrimaryEmail
        } | Export-Csv -Path "C:\Temp\Groups-Changed.csv" -NoTypeInformation -Append
    } catch {
        Write-Host "Failed to update primary address for $primaryEmail. Error: $_"
    }
}