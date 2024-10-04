# Install the Exchange Online module if not already installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
	Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

# Import the Exchange Online module
Import-Module ExchangeOnlineManagement


# Retrieve all users
$users = Get-Recipient -RecipientTypeDetails UserMailbox

foreach ($user in $users) {
	# Extract the username part of the primary SMTP address
	$username = $user.PrimarySmtpAddress.Split('@')[0]
	
	# Construct the new SMTP aliases
	$aliases = @(
		"smtp:$username@biteinvestments.com",
		"smtp:$username@bitesign.co",
		"smtp:$username@bitestream.co"
	)
	
	# Update the user's SMTP aliases
	try {
		Set-Mailbox -Identity $user.Identity -EmailAddresses @{add=$aliases}
		Write-Host "Successfully added SMTP aliases for user: $($user.DisplayName)"
	} catch {
		Write-Host "Failed to add SMTP aliases for user: $($user.DisplayName)"
		Write-Host $_.Exception.Message
	}
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false