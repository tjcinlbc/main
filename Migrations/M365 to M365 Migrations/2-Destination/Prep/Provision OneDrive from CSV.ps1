# Import the SharePoint Online module
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -AllowClobber -Scope CurrentUser
Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable
Import-Module -Name Microsoft.Online.SharePoint.PowerShell
Install-PSResource -Name Microsoft.Online.SharePoint.PowerShell	-Reinstall

#THIS MUST BE RAN IN WINDOWS POWERSHELL OR ELSE YOU GET A 400 BAD REQUEST ERROR.
# Connect to SharePoint Online
$adminUrl = "https://iuvobioscience-admin.sharepoint.com/" # Change this to your SharePoint admin URL
try {
    Connect-SPOService -Url $adminUrl
    $connected = $true
} catch {
    Write-Host "Failed to connect to SharePoint Online: $_.Exception.Message"
    $connected = $false
}
if ($connected) {
    # Import user list from CSV
    $userListPath = "C:\temp\oneDriveAccounts.csv" # Update the path to your CSV file
    $userList = Import-Csv -Path $userListPath
    # Provision OneDrive for each user
    foreach ($user in $userList) {
        $upn = $user."user principal name"
        if ($upn -like "*#EXT#*") {
            Write-Host "Skipping external user $upn"
            continue
        }
        try {
            # Request the personal site to provision OneDrive
            Request-SPOPersonalSite -UserEmails $upn
            Write-Host "OneDrive provisioning requested for $upn"
        } catch {
            Write-Host "Failed to provision OneDrive for ${upn}:$($_.Exception.Message)"
        }
    }
    Write-Host "OneDrive provisioning process completed."
} else {
    Write-Host "Cannot proceed with OneDrive provisioning due to connection issues."
}