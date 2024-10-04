# Install and Import SharePoint Online module
#Install-Module -Name Microsoft.Online.SharePoint.PowerShell -AllowClobber -Scope CurrentUser -Force
#Import-Module -Name Microsoft.Online.SharePoint.PowerShell -Verbose

# Connect to SharePoint Online
$adminUrl = "https://intereum-admin.sharepoint.com/" # Change to your SharePoint admin URL
Connect-SPOService -Url $adminUrl

# Import site list from CSV
$siteListPath = "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Interior Investments\20240812 - 365 Migration\SharePoint Sites - CorpConc.csv" # Update the path to your CSV file
$siteList = Import-Csv -Path $siteListPath

# Set a constant site owner for all sites
$siteOwner = "cspadmin@intereum.com"

# Provision SharePoint sites for each entry in the CSV
foreach ($site in $siteList) {
    $siteUrl = $site.URL.Trim()
    $siteTitle = 'site name'

    # Validate URL
    if (-not [Uri]::IsWellFormedUriString($siteUrl, [UriKind]::Absolute)) {
        Write-Host "Site URL is not well-formed: $siteUrl"
        continue
    }

    # Validate Title
    if ([string]::IsNullOrEmpty($siteTitle)) {
        Write-Host "Site title is null or empty for URL: $siteUrl"
        continue
    }

    # Check if site exists and create if it doesn't
    try {
        $existingSite = Get-SPOSite -Identity $siteUrl -ErrorAction Stop
        Write-Host "Site already exists: $siteUrl"
    } catch {
        if ($_.Exception.Message -like "*Cannot get site*") {
            try {
                New-SPOSite -Url $siteUrl -Owner $siteOwner -Title $siteTitle -Template "STS#3" -StorageQuota 25000 # Use desired template and set StorageQuota
                Write-Host "Site created successfully: $siteUrl"
            } catch {
                Write-Host "Failed to create site: $($_.Exception.Message)"
            }
        } else {
            Write-Host "Error checking site existence: $($_.Exception.Message)"
        }
    }
}
Write-Host "SharePoint site provisioning process completed."
