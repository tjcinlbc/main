Get-PublicFolderClientPermission "\6233-0006"
Add-PublicFolderClientPermission -Identity "\6299-0012" -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer -Recurse:$recurseOnFolders


Get-PublicFolder -Identity "\6233-0006" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6233-0007" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6237-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6237-0002" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6229-0018" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6238-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6239-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6239-0002" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6239-0003" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6241-0005" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6243-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6244-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\Business Development A-L" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\Business Development M-Z" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\PMI Shared Calendar" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "6232-0001" -Recurse | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights Reviewer
Get-PublicFolder -Identity "\6221-0018" -Recurse | Add-PublicFolderClientPermission -User tcheney@promedica-intl.com -AccessRights Owner





Set-Mailbox –Identity migrationwiz@iuvobioscience.onmicrosoft.com –DefaultPublicFolderMailbox Migrationwiz

Set-Mailbox –Identity migrationwiz@yourdomain.onmicrosoft.com –DefaultPublicFolderMailbox Migrationwiz@yourdomain.onmicrosoft.com

Get-PublicFolder -Identity "\6221-0018" -Recurse | ForEach-Object {
    Get-PublicFolderClientPermission -Identity $_.Identity
} | Add-PublicFolderClientPermission -User migrationwiz@promedicaintlcro.onmicrosoft.com -AccessRights PublishingEditor

New-PublicFolderMoveRequest -Folders \Dev\CustomerEngagements,\Dev\RequestsforChange,\Dev\Usability -TargetMailbox DeveloperReports01

New-PublicFolderMoveRequest -Folders "\6232-0001\6232-1 Internal Corr" -TargetMailbox "6232-0001 Internal Corr - Copy"

a