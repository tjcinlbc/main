# Connect to SharePoint Online
$adminUrl = "https://biteinvestments-admin.sharepoint.com/" # Change to your SharePoint admin URL
Connect-SPOService -Url $adminUrl

# Import site list from CSV
$siteListPath = "C:\path\to\your\csvfile.csv" # Update the path to your CSV file
$siteList = Import-Csv -Path $siteListPath

# Specify the user to be added as a site admin
$userToBeSiteAdmin = "travis@biteinvestments.onmicrosoft.com"

foreach ($site in $siteList) {
    $siteUrl = $site.URL.Trim()

    # Validate URL
    if (-not [Uri]::IsWellFormedUriString($siteUrl, [UriKind]::Absolute)) {
        Write-Host "Site URL is not well-formed: $siteUrl"
        continue
    }

    # Connect to the site
    $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
    $ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($user, $password)

    # Get the Owners group
    $web = $ctx.Web
    $group = $web.SiteGroups.GetByName("Owners") # Adjust if your admin group has a different name
    $ctx.Load($group)
    $ctx.ExecuteQuery()

    # Add the user to the group
    $userCreationInformation = New-Object Microsoft.SharePoint.Client.UserCreationInformation
    $userCreationInformation.Email = $userToBeAdded
    $userCreationInformation.LoginName = $userToBeAdded
    $userCreationInformation.Title = "Site Admin"
    $user = $group.Users.Add($userCreationInformation)
    $ctx.ExecuteQuery()

    Write-Host "Added $userToBeAdded to the Owners group of $siteUrl"
}

Write-Host "Process completed."