# Ensure the module is available
Install-Module Microsoft.Graph -AllowClobber -Force
# Ensure the Microsoft Graph PowerShell SDK is loaded
Import-Module Microsoft.Graph
# Check for updates
Update-Module Microsoft.Graph
# Connect to Microsoft Graph with necessary permissions
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"
# List available SKUs to find the correct GUID
# Get-MgSubscribedSku | Select-Object SkuId, SkuPartNumber

# Define the path to the CSV file and the SKU ID for License
$csvPath = "C:\Users\TravisCheney\Downloads\users_9_23_2024 9_21_30 PM.csv"
$SkuId = "05e9a617-0261-4cee-bb44-138d3ef5d965"

# Import the CSV file
$upnList = Import-Csv -Path $csvPath

# Iterate through each UPN in the list
foreach ($upn in $upnList) {
    try {
        # Retrieve the user's ID using the new column name
        $userId = (Get-MgUser -Filter "userPrincipalName eq '$($upn.'user principal name')'").Id
        if ($userId) {
            # Set the usage location for the user
            $usageLocation = if ($upn.'usage location') { $upn.'usage location' } else { "US" }Default to "US" if not specified I think this script fills in the usage location, and then has it reset by what is in the CSV
            Update-MgUser -UserId $userId -UsageLocation $usageLocation

            # Prepare the license to add
            $licenseToAdd = @{'skuId' = $SkuId; 'disabledPlans' = @()}
            # Assign the license
            Set-MgUserLicense -UserId $userId -AddLicenses @($licenseToAdd) -RemoveLicenses @()
            Write-Output "Successfully assigned License to $($upn.'user principal name') with usage location set to $usageLocation"
        } else {
            Write-Output "User not found: $($upn.'user principal name')"
        }
    } catch {
        Write-Output "Error assigning license or setting usage location for $($upn.'user principal name'): $_"
    }
}