# Import the SharePoint Online module
# just fails every time
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -AllowClobber -Scope CurrentUser -Force
Import-Module -Name Microsoft.Online.SharePoint.PowerShell -Verbose

# Connect to SharePoint Online
$adminUrl = "https://biteinvestmentseurope-admin.sharepoint.com/" # Change this to your SharePoint admin URL
try {
    Connect-SPOService -Url $adminUrl
    $connected = $true
    Write-Host "Connected to SharePoint Online successfully."
} catch {
    Write-Host "Failed to connect to SharePoint Online: $($_.Exception.Message)"
    $connected = $false
}

if ($connected) {
    # Import site list from CSV
    $siteListPath = "C:\temp\Sites_20240712154951191.csv" # Update the path to your CSV file
    $siteList = Import-Csv -Path $siteListPath

        # Provision SharePoint sites for each entry in the CSV
    foreach ($site in $siteList) {
        # Check and trim each property if it's not null
        $siteUrl = if ($null -ne $site.'URL') { $site.'URL'.Trim() } else { $null }
        $siteTitle = if ($null -ne $site.'site name') { $site.'site name'.Trim() } else { $null }
        $siteOwner = if ($null -ne $site.'created by') { $site.'created by'.Trim() } else { $null }
        $template = if ($null -ne $site.'Template') { $site.'Template'.Trim() } else { $null }

        # Validate parameters
        if (-not [Uri]::IsWellFormedUriString($siteUrl, [UriKind]::Absolute)) {
            Write-Host "Site URL is not well-formed: $siteUrl"
            continue
        }
        if (-not $siteOwner -match "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
            Write-Host "Site owner email appears to be invalid: $siteOwner"
            continue
        }

        try {
            Write-Host "Checking existence of site: $siteUrl"
            $existingSite = Get-SPOSite -Identity $siteUrl -ErrorAction Stop
            Write-Host "Site already exists: $siteUrl"
        } catch {
            if ($_.Exception.Message -like "*Cannot get site*") {
                Write-Host "Site does not exist, attempting to create: $siteUrl"
                $retryCount = 0
                $maxRetries = 3
                while ($retryCount -lt $maxRetries) {
                    try {
                        New-SPOSite -Url $siteUrl -Owner $siteOwner -Title $siteTitle -Template $template -ErrorAction Stop
                        Write-Host "Site created successfully: $siteUrl"
                        break
                    } catch {
                        Write-Host "Attempt $($retryCount + 1) failed to create site at ${siteUrl}: $($_.Exception.Message)"
                        $retryCount++
                        if ($retryCount -eq $maxRetries) {
                            Write-Host "Failed to create site after $maxRetries attempts."
                            break
                        } else {
                            Start-Sleep -Seconds 5
                        }
                    }
                }
            } else {
                Write-Host "Error checking existence of site ${siteUrl}: $($_.Exception.Message)"
                # Additional diagnostic information
                Write-Host "Exception Type: $($_.Exception.GetType().FullName)"
                Write-Host "Stack Trace: $($_.Exception.StackTrace)"
            }
        }
    }
    Write-Host "SharePoint site provisioning process completed."
} else {
    Write-Host "Script terminated due to failure in connecting to SharePoint Online."
}