# Define the directory path
$directoryPath = "C:\Temp"

# Create an array to store the results
$results = @()

# Get a list of directories in the specified directory
$directories = Get-ChildItem -Path $directoryPath -Directory -Recurse

# Loop through each directory
foreach ($directory in $directories) {
    # Get the directory's ACL (Access Control List)
    $acl = Get-Acl -Path $directory.FullName

    # Loop through each ACE (Access Control Entry) in the ACL
    foreach ($ace in $acl.Access) {
        # Create an object to store the results
        $result = New-Object PSObject -Property @{
            FolderName = $directory.FullName
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

# Export the results to a CSV file with columns in the desired order
$results | Select-Object FolderName, "AD Group or User", Permissions, Inherited | Export-Csv -Path "C:\Temp\NTFS-Report.csv" -NoTypeInformation
