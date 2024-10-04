# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve all users from Active Directory with UserPrincipalName and objectGUID
$users = Get-ADUser -Filter * -Property UserPrincipalName, objectGUID

# Initialize an array to hold the custom objects
$userData = @()

# Loop through each user
foreach ($user in $users) {
	# Convert objectGUID to Base64 string
	$guidBytes = [System.Guid]::Parse($user.objectGUID).ToByteArray()
	$base64Guid = [Convert]::ToBase64String($guidBytes)

	# Create a custom object with UserPrincipalName and Base64 string
	$userObject = [PSCustomObject]@{
		UserPrincipalName = $user.UserPrincipalName
		Base64ObjectGUID = $base64Guid
	}

	# Add the custom object to the array
	$userData += $userObject
}

# Export the custom objects to a CSV file
$userData | Export-Csv -Path "C:\temp\UserData.csv" -NoTypeInformation