# Define the directory path
$directoryPath = "C:\Temp"

# Create an array to store the results
$results = @()

# Get a list of items (files and folders) in the directory
$items = Get-ChildItem -Path $directoryPath -Recurse

# Loop through each item
foreach ($item in $items) {
    # Get the item's ACL (Access Control List)
    $acl = Get-Acl -Path $item.FullName

    # Loop through each ACE (Access Control Entry) in the ACL
    foreach ($ace in $acl.Access) {
        # Create an object to store the results
        $result = New-Object PSObject -Property @{
            FolderName = $item.FullName
            "AD Group or User" = $ace.IdentityReference
            Permissions = $ace.FileSystemRights
            Inherited = $ace.IsInherited
        }

        # Add the result to the results array
        $results += $result
    }
}

# Output the results with column headers
$results | Format-Table -Property FolderName, "AD Group or User", Permissions, Inherited -AutoSize
