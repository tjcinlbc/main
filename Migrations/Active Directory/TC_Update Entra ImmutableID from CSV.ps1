# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Load the CSV file
$csv = Import-Csv -Path "C:\temp\usersguid2.csv"

# Iterate through each row in the CSV
foreach ($row in $csv) {
	$userPrincipalName = $row.UserPrincipalName
	$base64ObjectGuid = $row.Base64ObjectGUID
	
	# Get the user
	$user = Get-AzureADUser -Filter "UserPrincipalName eq '$userPrincipalName'"
	
	if ($user) {
		# Update the user's On-premises immutable ID
		Set-AzureADUser -ObjectId $user.ObjectId -ImmutableId $base64ObjectGuid
	} else {
		Write-Output "User $userPrincipalName not found."
	}
}

Write-Output "Update completed."