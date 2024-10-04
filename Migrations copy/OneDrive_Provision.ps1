Import-Module -name Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url https://awp-admin.sharepoint.com

$list = @()
#Counters
$i = 0


$Userlist = Import-Csv -Path "C:\Users\ZachThomas\Downloads\Fly_OneDrive_Project_Mappings_SASS OD_20240730153939.csv" | foreach { 
    $Data = [PSCustomObject]@{
        UPN = $_."Destination user"
    }
    $Data
}

foreach ($u in $Userlist) {
    $upn = $u.UPN
        #We reached the limit
        Request-SPOPersonalSite -UserEmails $upn -NoWait
        Start-Sleep -Milliseconds 655
}

if ($i -gt 0) {
    Request-SPOPersonalSite -UserEmails $list -NoWait
}