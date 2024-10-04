# Install and Import the full Microsoft.Graph module
Install-Module Microsoft.Graph -AllowClobber -Force
Update-Module Microsoft.Graph
Import-Module -Name Microsoft.Graph


# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All", "User.Read.All", "Directory.ReadWrite.All"

# Path to the CSV file
$csvPath = "c:\temp\SecurityGroupMembersAndOwners.csv"

# Read the CSV file
$groupsInfo = Import-Csv -Path $csvPath

# Group the information
$groupedInfo = $groupsInfo | Group-Object -Property "Security Group DisplayName"

foreach ($group in $groupedInfo) {
    $groupName = $group.Name
    # Check if the security group already exists
    $existingGroup = Get-MgGroup -Filter "displayName eq '$groupName' and securityEnabled eq true" | Select-Object -First 1

    if (-not $existingGroup) {
        # Create a new group
        $newGroupParams = @{
            DisplayName = $groupName
            MailEnabled = $false
            SecurityEnabled = $true
            MailNickname = ($groupName -replace ' ', '').ToLower()
        }
        $newGroup = New-MgGroup @newGroupParams
        Write-Host "Created security group: $groupName"
        $existingGroup = $newGroup
    } else {
        Write-Host "Security group $groupName already exists. Adding users..."
    }

    # Process members and owners
    foreach ($person in $group.Group) {
        $personEmail = $person."Person Email".Trim()
        if ($personEmail -ne "N/A") {
            $filter = "userPrincipalName eq '$personEmail'"
            $user = Get-MgUser -Filter $filter | Select-Object -First 1
            if ($user) {
                $role = $person."Role"
                # Assuming $existingGroup and $user are already defined and have their Id properties available
                if ($role -eq "Owner") {
                    # Check if the user is already an owner
                    $isOwner = Get-MgGroupOwner -GroupId $existingGroup.Id | Where-Object { $_.Id -eq $user.Id }
                    if (-not $isOwner) {
                        # Correctly constructing the OdataId for the user
                        $odataId = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
                        New-MgGroupOwnerByRef -GroupId $existingGroup.Id -OdataId $odataId -ErrorAction SilentlyContinue
                        Write-Host "Added $personEmail as an owner to $groupName"
                    }
                } else {
                    # Check if the user is already a member
                    $isMember = Get-MgGroupMember -GroupId $existingGroup.Id | Where-Object { $_.Id -eq $user.Id }
                    if (-not $isMember) {
                        # Correctly constructing the OdataId for the user
                        $odataId = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
                        New-MgGroupMemberByRef -GroupId $existingGroup.Id -OdataId $odataId -ErrorAction SilentlyContinue
                        Write-Host "Added $personEmail as a member to $groupName"
                    }
                }    
            } else {
                Write-Host "User $personEmail not found."
            }
        }
    }
}
Write-Host "Processing completed."