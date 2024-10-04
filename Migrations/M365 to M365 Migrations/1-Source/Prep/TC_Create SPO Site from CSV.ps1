# Connect to SharePoint Online Admin Center
$adminUrl = "https://biteinvestmentseurope-admin.sharepoint.com"
Connect-SPOService -Url $adminUrl

# Import site list from CSV
$siteListPath = "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\BITE Investments\20240520 - 365 Migration\New SharePoint Groups.csv" # Update the path to your CSV file
$siteList = Import-Csv -Path $siteListPath

# Specify the user to be added as a site owner
$siteOwner = "migrationwiz@biteinvestmentseurope.onmicrosoft.com"

foreach ($site in $siteList) {
	$siteName = $site."New Group Name".Trim()
	$siteUrl = "https://biteinvestmentseurope.sharepoint.com/sites/" + $siteName.Replace(" ", "").ToLower()

	# Validate URL
	if (-not [Uri]::IsWellFormedUriString($siteUrl, [UriKind]::Absolute)) {
		Write-Host "Site URL is not well-formed: $siteUrl"
		continue
	}

	# Create the site
	try {
		New-SPOSite -Url $siteUrl -Owner $siteOwner -StorageQuota 1000 -Title $siteName
		Write-Host "Site created successfully: $siteUrl with title $siteName"
	} catch {
		Write-Host "Failed to create site: $siteUrl"
		Write-Host $_.Exception.Message
	}
}