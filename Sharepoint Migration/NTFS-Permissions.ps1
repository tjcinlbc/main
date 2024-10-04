# Define the root folder you want to start parsing
$rootFolder = "C:\Temp"

# Define the output CSV file path
$outputFile = "C:\Temp\File.csv"

# Create an array to store folder permission data
$folderPermissions = @()

# Function to recursively get folder permissions
function Get-FolderPermissions {
    param (
        [string]$folderPath
    )

    $folder = Get-Item -LiteralPath $folderPath

    # Get NTFS permissions for the folder
    $acl = $folder.GetAccessControl('Access')

    # Iterate through access rules and collect data
    foreach ($accessRule in $acl.Access) {
        $folderPermissions += [PSCustomObject]@{
            "Folder" = $folder.FullName
            "User" = $accessRule.IdentityReference
            "Permissions" = $accessRule.FileSystemRights
            "Inheritance" = $accessRule.InheritanceFlags
            "Propagation" = $accessRule.PropagationFlags
        }
    }

    # Recursively process subfolders
    $subfolders = Get-ChildItem -Path $folderPath -Directory
    foreach ($subfolder in $subfolders) {
        Get-FolderPermissions -folderPath $subfolder.FullName
    }
}

# Start parsing and collecting folder permissions
Get-FolderPermissions -folderPath $rootFolder

# Export folder permissions to a CSV file
$folderPermissions | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "Folder permissions exported to $outputFile"
