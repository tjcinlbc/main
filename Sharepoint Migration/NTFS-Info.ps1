$OutFile = "c:\temp\ExplicitACLs.csv"
"Path;Access;Identity" | Out-File $OutFile
$TopFolders = Get-ChildItem "C:\Users" -Directory
ForEach ($TopFolder In $TopFolders) {
    Write-Host Processing $TopFolder.FullName ...
    $Folders = Get-ChildItem -Path $TopFolder.FullName -Recurse -Directory
    ForEach ($Folder In $Folders) {
        $ACL = Get-Acl $Folder.FullName
        ForEach ($Access In $ACL.Access) {
            If ($Access.IsInherited -eq $False) {
                $Output = $Folder.FullName + ";" + $Access.FileSystemRights + ";" + $Access.IdentityReference
                $Output | Out-File $OutFile -Append
                Write-Host $Output
            }
        }
    }
}



$FolderPath = Get-ChildItem -Directory -Path "C:\Users" -Recurse -Force
$Output = @()
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
$Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
$Output += New-Object -TypeName PSObject -Property $Properties
    }
}
$Output | Out-File C:\Temp\folder-permission.txt

