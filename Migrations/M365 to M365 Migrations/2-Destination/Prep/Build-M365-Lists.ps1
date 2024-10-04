# Install-Module -Name ExchangeOnlineManagement -Force
# Connect-ExchangeOnline


# Path to the CSV file
$csvPath = "C:\temp\GroupMembersAndOwnersWithPrivacy.csv" #THIS NEEDS TO BE CHANGED
# Your email to be removed from owners
#$yourEmail = "cspadmin@contoso.com"
$yourEmail = "migrationwiz@biteinvestments.europe.com"


# Read the CSV file
$groupsInfo = Import-Csv -Path $csvPath

# Group the information by "Group DisplayName"
$groupedInfo = $groupsInfo | Group-Object -Property "Group DisplayName"

foreach ($group in $groupedInfo) {
    $groupName = $group.Name
    $groupEmail = ($group.Group | Select-Object -Unique "NewTenantMS Group Email")."NewTenantMS Group Email"
    $allowExternalEmailsString = ($group.Group | Select-Object -Unique "AllowExternalEmails")."AllowExternalEmails"
    $privacy = ($group.Group | Select-Object -Unique "Privacy")."Privacy"

    # Convert AllowExternalEmails to a boolean
    $allowExternalEmails = $allowExternalEmailsString -eq "true"

    # Check if the Microsoft 365 Group already exists
    $existingGroup = Get-UnifiedGroup -Identity $groupEmail -ErrorAction SilentlyContinue
    
    if (-not $existingGroup) {
        # Create the Microsoft 365 Group if it doesn't exist
        New-UnifiedGroup -DisplayName $groupName -EmailAddress $groupEmail `
                         -AccessType $privacy -RequireSenderAuthenticationEnabled (-not $allowExternalEmails)
        Write-Host "Created Microsoft 365 Group: $groupName"
    } else {
        Write-Host "Microsoft 365 Group $groupName already exists."
        Set-UnifiedGroup -Identity $groupEmail -RequireSenderAuthenticationEnabled (-not $allowExternalEmails) `
                         -ErrorAction SilentlyContinue
    }

    # Temporarily add your account as an owner to manage the group (if not already an owner)
    Add-UnifiedGroupLinks -Identity $groupEmail -LinkType Owners -Links $yourEmail -ErrorAction SilentlyContinue

    # Process members and owners from CSV
    foreach ($person in $group.Group) {
        $personEmail = $person."NewTenantMS Person Email"
        $role = $person."Role"

        if ($role -eq "Owner" -and $personEmail -ne $yourEmail) {
            # Add as an owner
            Add-UnifiedGroupLinks -Identity $groupEmail -LinkType Members -Links $personEmail -ErrorAction SilentlyContinue
            Write-Host "Added $personEmail as a member to $groupName"
            Add-UnifiedGroupLinks -Identity $groupEmail -LinkType Owners -Links $personEmail -ErrorAction SilentlyContinue
            Write-Host "Added $personEmail as an owner to $groupName"
        }
        elseif ($role -eq "Member" -and $personEmail -ne $yourEmail) {
            # Add as a member
            Add-UnifiedGroupLinks -Identity $groupEmail -LinkType Members -Links $personEmail -ErrorAction SilentlyContinue
            Write-Host "Added $personEmail as a member to $groupName"
        }
    }

    # Remove your email from both the owners and members of the group
    Remove-UnifiedGroupLinks -Identity $groupEmail -LinkType Owners -Links $yourEmail -Confirm:$false -ErrorAction Continue
    Write-Host "Removed $yourEmail from the owners of $groupName."

    Remove-UnifiedGroupLinks -Identity $groupEmail -LinkType Members -Links $yourEmail -Confirm:$false -ErrorAction Continue
    Write-Host "Removed $yourEmail from the members of $groupName."


}

Write-Host "Processing completed."

