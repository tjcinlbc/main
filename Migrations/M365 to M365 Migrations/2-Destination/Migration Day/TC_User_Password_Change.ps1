#Install-Module Microsoft.Graph -Scope CurrentUser
#Import-Module Microsoft.Graph.Users
Connect-Graph -Scopes "User.ReadWrite.All", "Directory.AccessAsUser.All"

$Userlist = Import-Csv -Path "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\Interior Investments\20240812 - 365 Migration\usersMasterCorpConc.csv" | foreach { 
    $Data = [PSCustomObject]@{
        UPN = $_.NewUPN
    }
    $Data
}

foreach ($UPN in $Userlist) {
    $params = @{
        passwordProfile = @{
            password = '1stPWD!!'
            forceChangePasswordNextSignIn = $true
        }
    }
    Write-Host "Updating password for user: $($UPN.UPN)"
    Update-MgUser -UserId $UPN.UPN -BodyParameter $params
}

Write-Host "Password update completed for all users."

#Disconnect-MgGraph