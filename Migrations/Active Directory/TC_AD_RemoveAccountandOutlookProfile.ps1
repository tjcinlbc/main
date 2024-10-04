# Using wildcard patterns to remove Office and Outlook credentials
$credentialTargets = @(
    "*SSO_POP_Device*",
    "*MicrosoftAccount*",
    "*Outlook*",
    "*MicrosoftOffice*"
)

foreach ($target in $credentialTargets) {
    Write-Host "Attempting to remove credentials for: $target"
    cmdkey /list | Select-String -SimpleMatch $target | ForEach-Object {
        $credLine = $_.ToString()
        if ($credLine -match "Target: (.+)$") {
            $credTarget = $matches[1]
            Write-Host "Removing stored credentials: $credTarget"
            cmdkey /delete:$credTarget
        }
    }
}

# Function to remove Office 365 accounts from registry
function Remove-Office365Accounts {
    $office365RegPaths = @(
        "HKCU:\Software\Microsoft\Office\16.0\Common\Identity\Identities",
        "HKCU:\Software\Microsoft\Office\15.0\Common\Identity\Identities"
    )

    foreach ($path in $office365RegPaths) {
        if (Test-Path $path) {
            Write-Host "Removing Office 365 accounts from: $path"
            Remove-Item -Path $path -Recurse -Force
        } else {
            Write-Host "Registry path not found: $path"
        }
    }
}

# Call the function to remove Office 365 accounts
Remove-Office365Accounts

# Function to remove Outlook profiles from registry
function Remove-OutlookProfiles {
    Write-Host "Removing Outlook profiles and session data from registry..."

    $outlookProfilePaths = @(
        "HKCU:\Software\Microsoft\Office\Outlook\Profiles",
        "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles",
        "HKCU:\Software\Microsoft\Office\16.0\Outlook"
    )

    foreach ($path in $outlookProfilePaths) {
        if (Test-Path $path) {
            Write-Host "Removing Outlook profile data from: $path"
            Remove-Item -Path $path -Recurse -Force
        } else {
            Write-Host "Registry path not found: $path"
        }
    }
}

# Call the function to remove Outlook profiles
Remove-OutlookProfiles