# Connect-ExchangeOnline
# Path to the CSV file
$csvPath = "C:\temp\GroupMembersAndOwnersWithPrivacy.csv"

# Reading the CSV file
$groups = Import-Csv -Path $csvPath

foreach ($group in $groups) {
    $primaryEmail = $group."Group primary email"
    $newUPN = $group."new UPN"
    
    if (-not $primaryEmail -or -not $newUPN) {
        Write-Host "Skipping group due to missing primary email or new UPN. Group details: $($group | ConvertTo-Json)"
        continue
    }
    
    # Generate the new primary SMTP address and keep the old primary as an alias
    $newEmailAddresses = @("SMTP:$newUPN", "smtp:$primaryEmail")
    
    # Adding the new primary email address and setting the old primary as an alias
    try {
        # Update the email addresses for the group
        Set-UnifiedGroup -Identity $primaryEmail -EmailAddresses $newEmailAddresses -ErrorAction Stop
        Set-UnifiedGroup -Identity $primaryEmail -PrimarySmtpAddress $newUPN -ErrorAction Stop
        Write-Host "Successfully updated primary address to $newUPN for group $primaryEmail"
        
        # Add the old and new to a CSV in C:\Temp\Groups-Changed.csv append and don't replace
        [PSCustomObject]@{
            OldPrimaryEmail = $primaryEmail
            NewPrimaryEmail = $newUPN
        } | Export-Csv -Path "C:\temp\Groups-NewDestinationFinal-Output.csv" -NoTypeInformation -Append
    } catch {
        Write-Host "Failed to update primary address for $primaryEmail. Error: $_"
    }
}

# Handling distribution groups
$distroGroups = Import-Csv -Path $csvPath