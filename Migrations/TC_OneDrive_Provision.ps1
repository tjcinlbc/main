Connect-SPOService -Url https://sandersonstewart062-admin.sharepoint.com

$list = @()
#Counters
$i = 0


$Userlist = Import-Csv -Path "C:\temp\Bellecci-Coleman-OneDriveProvision.csv" | foreach { 
    $Data = [PSCustomObject]@{
        UPN = $_.UPN
    }
    $Data
}

foreach ($u in $Userlist) {
    $i++
    Write-Host "$i/$count"

    $upn = $u.UPN
    $list += $upn

    if ($i -eq 199) {
        #We reached the limit
        Request-SPOPersonalSite -UserEmails $list -NoWait
        Start-Sleep -Milliseconds 655
        $list = @()
        $i = 0
    
    }
}

if ($i -gt 0) {
    Request-SPOPersonalSite -UserEmails $list -NoWait
}