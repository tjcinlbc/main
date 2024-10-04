# Install-Module -Name ExchangeOnlineManagement -Force
# Connect-ExchangeOnline


# Path to the CSV file
$csvPath = "C:\temp\DistributionGroupMembersAndOwnersWithExternalEmails.csv"
# Your email to be removed from owners
$yourEmail = "csp@gopayhawk.onmicrosoft.com"

# Read the CSV file
$distroListInfo = Import-Csv -Path $csvPath

# Group the information by Distribution Group to handle each group individually
$groupedInfo = $distroListInfo | Group-Object -Property "Group Name"

foreach ($group in $groupedInfo) {
    $groupName = $group.Name
    $groupEmail = ($group.Group | Select-Object -Unique "Group primary email")."Group primary email"
    $allowExternalEmails = ($group.Group | Select-Object -Unique "AllowExternalEmails")."AllowExternalEmails"
    
    # Determine the value for RequireSenderAuthenticationEnabled
    $requireSenderAuthenticationEnabled = $allowExternalEmails -eq "false"
    
    # Check if the distribution group already exists
    $existingGroup = Get-DistributionGroup -Identity $groupEmail -ErrorAction SilentlyContinue
    
    if (-not $existingGroup) {
        # Create the distribution group
        New-DistributionGroup -Name $groupName -PrimarySmtpAddress $groupEmail -RequireSenderAuthenticationEnabled $requireSenderAuthenticationEnabled -ErrorAction Continue
        Write-Host "Created distribution group: $groupName with AllowExternalEmails set to $allowExternalEmails"
    } else {
        Write-Host "Distribution group $groupName already exists. Checking AllowExternalEmails setting..."
        # Update RequireSenderAuthenticationEnabled if necessary
        Set-DistributionGroup -Identity $groupEmail -RequireSenderAuthenticationEnabled $requireSenderAuthenticationEnabled
        Write-Host "Updated AllowExternalEmails for $groupName to $allowExternalEmails."
    }
    
    # Process owners and members
    foreach ($person in $group.Group) {
        $personEmail = $person."Person Email"
        $role = $person.Role
        if ($role -eq "Owner") {
            # Add as owner
            Set-DistributionGroup -Identity $groupEmail -ManagedBy $personEmail -BypassSecurityGroupManagerCheck -ErrorAction SilentlyContinue
            Write-Host "Added $personEmail as an owner of $groupName"
        } elseif ($role -eq "Member") {
            # Add as member
            try {
                Add-DistributionGroupMember -Identity $groupEmail -Member $personEmail -ErrorAction Stop
                Write-Host "Added $personEmail to $groupName as a member"
            } catch {
                Write-Host "Failed to add $personEmail to $groupName. Error: $_"
            }
        }
    }

    # Remove your account from the distribution group's ownership if it was added
    $existingOwners = Get-DistributionGroup -Identity $groupEmail | Select-Object -ExpandProperty ManagedBy
    if ($yourEmail -in $existingOwners) {
        Set-DistributionGroup -Identity $groupEmail -ManagedBy @{Remove=$yourEmail} -BypassSecurityGroupManagerCheck -ErrorAction SilentlyContinue
        Write-Host "Removed $yourEmail from the owners of $groupName."
    }
}
