# Import the required module
Import-Module -Name Microsoft.Graph.Authentication

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All", "Directory.Read.All"

$OutputFile = "c:\temp\SecurityGroupMembersAndOwners.csv" # New CSV Output file name
# Prepare Output file with headers
"Security Group DisplayName,Security Group Email,Person DisplayName, Person Email, Role" | Out-File -FilePath $OutputFile -Encoding UTF8

# Initialize an empty array to hold all security groups
$allSecurityGroups = @()

# Get the first batch of Security Groups from Office 365
$groupsResponse = Get-MgGroup -Top 999

# Add the first batch to the allSecurityGroups array
$allSecurityGroups += $groupsResponse

# While there is a next link, keep fetching and adding to the allSecurityGroups array
while ($null -ne $groupsResponse.'@odata.nextLink') {
    $groupsResponse = Get-MgGroup -Top 999 -SkipToken $groupsResponse.'@odata.nextLink'.Split('=')[-1]
    $allSecurityGroups += $groupsResponse
}

# Process each security group
foreach ($objSecurityGroup in $allSecurityGroups) {
    Write-Host "Processing $($objSecurityGroup.DisplayName)..."
    $groupMail = if ($null -eq $objSecurityGroup.Mail) { "N/A" } else { $objSecurityGroup.Mail }
    $groupDisplayName = if ($null -eq $objSecurityGroup.DisplayName) { "N/A" } else { $objSecurityGroup.DisplayName }
    
    # Get group owners
    $groupOwners = Get-MgGroupOwner -GroupId $objSecurityGroup.Id -All
    foreach ($owner in $groupOwners) {
        $ownerDetails = $null
        if ($owner -is [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUser]) {
            $ownerDetails = $owner
        } else {
            # Attempt to fetch user details by ID, assuming owner could be a service principal or another type not directly handled
            try {
                $ownerDetails = Get-MgUser -UserId $owner.Id -ErrorAction Stop
            } catch {
                Write-Host "Failed to fetch details for owner with ID: $($owner.Id)"
            }
        }
        if ($ownerDetails) {
            $ownerMail = if ($null -eq $ownerDetails.Mail) { $ownerDetails.UserPrincipalName } else { $ownerDetails.Mail }
            $ownerDisplayName = $ownerDetails.DisplayName
            "$groupDisplayName,$groupMail,$ownerDisplayName,$ownerMail,Owner" | Out-File -FilePath $OutputFile -Encoding UTF8 -Append
        }
    }
    
    # Get members of this group
    $objSGMembers = Get-MgGroupMember -GroupId $objSecurityGroup.Id -All
    foreach ($objMember in $objSGMembers) {
        $memberDetails = $null
        if ($objMember -is [Microsoft.Graph.PowerShell.Models.IMicrosoftGraphUser]) {
            $memberDetails = $objMember
        } else {
            # Attempt to fetch user details by ID
            try {
                $memberDetails = Get-MgUser -UserId $objMember.Id -ErrorAction Stop
            } catch {
                Write-Host "Failed to fetch details for member with ID: $($objMember.Id)"
            }
        }
        if ($memberDetails) {
            $displayName = $memberDetails.DisplayName
            $email = if ($null -eq $memberDetails.Mail) { "N/A" } else { $memberDetails.Mail }
            "$groupDisplayName,$groupMail,$displayName,$email,Member" | Out-File -FilePath $OutputFile -Encoding UTF8 -Append
        }
    }
}