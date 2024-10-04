
# Install-Module -Name ExchangeOnlineManagement -Force
# Connect-ExchangeOnline

# Specify the path to your CSV file
$csvPath = "C:\Temp\ListofEmailAliases.csv" #THIS NEEDS TO BE CHANGED

# Read the CSV file
$groups = Import-Csv -Path $csvPath

# Loop through each group in the CSV
foreach ($group in $groups) {
    # Extract GroupName and the new alias
    $groupName = $group.GroupName
    $newAlias = $group.NewAlias

    # Retrieve the current email addresses. The command differs based on whether it's a distro group or an M365 group.
    # For Distribution Groups
    $distroGroup = Get-DistributionGroup -Identity $groupName -ErrorAction SilentlyContinue
    if ($distroGroup) {
        $currentEmailAddresses = $distroGroup.EmailAddresses
        $newEmailAddresses = $currentEmailAddresses + "smtp:$newAlias"
        Set-DistributionGroup -Identity $groupName -EmailAddresses $newEmailAddresses
        Write-Host "Added alias $newAlias to Distribution Group $groupName"
    }

    # For Microsoft 365 Groups
    $m365Group = Get-UnifiedGroup -Identity $groupName -ErrorAction SilentlyContinue
    if ($m365Group) {
        $currentEmailAddresses = $m365Group.EmailAddresses
        $newEmailAddresses = $currentEmailAddresses + "smtp:$newAlias"
        Set-UnifiedGroup -Identity $groupName -EmailAddresses $newEmailAddresses
        Write-Host "Added alias $newAlias to Microsoft 365 Group $groupName"
    }

    # If neither, then the group was not found
    if (-not $distroGroup -and -not $m365Group) {
        Write-Host "Group $groupName not found."
    }
}

# Disconnect from Exchange Online
#Disconnect-ExchangeOnline -Confirm:$false
