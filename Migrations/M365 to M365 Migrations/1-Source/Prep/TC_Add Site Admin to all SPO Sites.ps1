# Install the SharePoint Online Management Shell module if not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
	Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -AllowClobber
}

# Import the SharePoint Online Management Shell module
Import-Module Microsoft.Online.SharePoint.PowerShell

# Connect to the SharePoint Online admin center
$adminUrl = "https://biteinvestments-admin.sharepoint.com/"
Connect-SPOService -Url $adminUrl

# Retrieve all active SharePoint sites
$sites = Get-SPOSite -Limit All

# User to be added as site admin
$userEmail = "migrationwiz@biteinvestments.onmicrosoft.com"

foreach ($site in $sites) {
	try {
		# Add the user as a site admin
		Set-SPOUser -Site $site.Url -LoginName $userEmail -IsSiteCollectionAdmin $true
		Write-Host "Successfully added $userEmail as site admin to site: $($site.Url)"
	} catch {
		Write-Host "Failed to add $userEmail as site admin to site: $($site.Url)"
		Write-Host $_.Exception.Message
	}
}