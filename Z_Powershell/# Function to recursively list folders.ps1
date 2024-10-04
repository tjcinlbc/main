# Function to recursively list folders and messages
function List-OutlookFoldersAndMessages {
    param (
        $Folder,
        [int]$Indent = 0
    )

    $folderData = @{
        FolderName = $Folder.Name
        Messages = @()
        SubFolders = @()
    }

    foreach ($item in $Folder.Items) {
        try {
            # Check if the item is a MailItem
            if ($item.MessageClass -eq "IPM.Note") {
                $folderData.Messages += @{
                    Subject = $item.Subject
                    EntryID = $item.EntryID
                }
            }
        } catch {
            $folderData.Messages += @{
                Subject = "Error accessing item"
                EntryID = "N/A"
            }
        }
    }

    foreach ($subFolder in $Folder.Folders) {
        $folderData.SubFolders += List-OutlookFoldersAndMessages -Folder $subFolder -Indent ($Indent + 2)
    }

    return $folderData
}

# Create an Outlook COM object
$outlook = New-Object -ComObject Outlook.Application
$namespace = $outlook.GetNamespace("MAPI")

# Prompt for PST file path
$pstFilePath = Read-Host "Enter the full path to the PST file"

try {
    # Add the PST file to Outlook
    $namespace.AddStore($pstFilePath)
    Write-Output "PST file added successfully."

    # Try to find the root folder by checking all stores
    $rootFolder = $null
    foreach ($store in $namespace.Stores) {
        if ($store.FilePath -eq $pstFilePath) {
            $rootFolder = $store.GetRootFolder()
            break
        }
    }

    if ($rootFolder) {
        # List all folders, subfolders, and messages with their EntryIDs
        $pstData = List-OutlookFoldersAndMessages -Folder $rootFolder

        # Convert the data to JSON
        $jsonOutput = $pstData | ConvertTo-Json -Depth 10

        # Save the JSON output to a file
        $outputFilePath = "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Desktop\pst_structure.json"
        $jsonOutput | Out-File -FilePath $outputFilePath -Encoding UTF8

        Write-Output "Folder structure and messages saved to $outputFilePath"

        try {
            # Remove the PST file from Outlook
            $namespace.RemoveStore($rootFolder)
            Write-Output "PST file removed successfully."
        } catch {
            Write-Output "Error removing the PST file from Outlook: $_"
        }
    } else {
        Write-Output "PST file not found or could not be opened."
    }
} catch {
    Write-Output "Error adding the PST file to Outlook: $_"
}
