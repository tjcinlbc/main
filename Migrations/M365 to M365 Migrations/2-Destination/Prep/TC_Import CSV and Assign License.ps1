# Ensure you have the necessary permissions
# You need to be a Global Administrator or have the User Administrator role in Azure AD

# Define the SKU ID for the 365 Business Basic license
$businessBasicSkuId = "05e9a617-0261-4cee-bb44-138d3ef5d965"

# Import the CSV file
$csvPath = "C:\Users\TravisCheney\Downloads\users_9_23_2024 6_41_13 PM.csv"
$users = Import-Csv -Path $csvPath

# Authenticate with Microsoft Graph with the necessary permissions
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All", "User.ReadWrite.All"

# Assign the Business Basic license to each user
foreach ($user in $users) {
	$userPrincipalName = $user."user principal name"
	$userDetails = Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'"

	if ($userDetails) {
		$userId = $userDetails.Id
		$licenseDetails = @{
			AddLicenses = @(@{ SkuId = $businessBasicSkuId })
			RemoveLicenses = @()
		}
		try {
			Set-MgUserLicense -UserId $userId -BodyParameter $licenseDetails
			Write-Host "License assigned to: $userPrincipalName"
		} catch {
			Write-Host "Failed to assign license to: $userPrincipalName. Error: $_"
		}
	} else {
		Write-Host "User not found: $userPrincipalName"
	}
}