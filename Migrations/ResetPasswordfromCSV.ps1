# Import the MSOnline module
Import-Module MSOnline

# Connect to Office 365
Connect-MsolService

# Define the path to the CSV file
$csvPath = "C:\temp\bite-migrationcredentials.csv" # Update this path to your CSV file location

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV
foreach ($user in $users) {
	try {
		# Reset the password for the user
		Set-MsolUserPassword -UserPrincipalName $user.'User principal name' -NewPassword $user.password -ForceChangePassword $true
	} catch {
		# Log the error for the user whose password failed to change
		Write-Host "Failed to change password for $($user.'User principal name'): $_"
	}
}