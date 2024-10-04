#CreateTeamsFromCSV

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Teams
Import-Module Microsoft.Graph.Sites
 
# Authenticate to Graph API
Connect-MgGraph -Scopes "Group.ReadWrite.All", "TeamSettings.ReadWrite.All", "Sites.ReadWrite.All", "User.Read.All"

$CSV = Import-Csv -Path "C:\Users\ZachThomas\OneDrive - Irvine, Trusted Tech Team\Documents\ANG_Revised Missing Teams.csv"

$Data = @()

foreach ($row in $csv) {
    $TeamName = $($row.Team)
    $Privacy = $row.open
    #$MailNickname = $($row.Groupalias)
    #$OldGroupEmail = $($row.GPE)

    # Create a Team
    $teamParams = @{
        "template@odata.bind" = "https://graph.microsoft.com/v1.0/teamsTemplates('standard')"
        DisplayName           = $TeamName
        #Description           = "Test Team"
        #MailNickname          = $MailNickname
        Visibility            = $Privacy
        MemberSettings        = @{ 
            AllowCreatePrivateChannels = $false 
            AllowUserEditMessages      = $true 
        }
        GuestSettings         = @{
            AllowCreateUpdateChannels = $false 
            AllowDeleteChannels       = $false 
        }
        MessagingSettings     = @{
            AllowUserEditMessages   = $true 
            AllowUserDeleteMessages = $false 
        }
        FunSettings           = @{
            AllowGiphy         = $true 
            GiphyContentRating = "Strict" 
        }
        Members               = @(
            @{
                "@odata.type"     = "#microsoft.graph.aadUserConversationMember"
                "roles"           = @("owner")
                "user@odata.bind" = "https://graph.microsoft.com/v1.0/users('sschilling@angstrom-usa.com')"
            }
        )
    }
 
    New-MgTeam -BodyParameter $teamParams
    <#Start-Sleep -Seconds 60
    $Team = Get-MgTeam -Filter "startswith(displayName, '$($TeamName)')"
    $TID = $team.Id

    $Group = Get-MGGroup -GroupId $TID
    $NewGroupEmail = $Group.Mail

    $Data += [PSCustomObject]@{
        TeamName      = $TeamName
        Groupalias    = $Groupalias
        OldGroupEmail = $OldGroupEmail
        NewGroupEmail = $NewGroupEmail
    }
    $Data#>
}

#$Data | Export-Csv -Path "C:\Users\ZachThomas\Downloads\Angstrom_Teams.csv" -NoTypeInformation

$GroupList = foreach ($row in $csv) {
    $Group = $null
    $NewGroupEmail = $null
    $TeamName = $($row.Team)
    $Privacy = $row.Privacy
    #$MailNickname = $($row.Groupalias)
    #$OldGroupEmail = $($row.GPE)
    $Team = Get-MgTeam -Filter "startswith(displayName, '$($TeamName)')"
    $TID = $team.Id

    $Group = Get-MGGroup -GroupId $TID
    $NewGroupEmail = $Group.Mail

    $Data = [PSCustomObject]@{
        TeamName      = $TeamName
        Groupalias    = $Groupalias
        OldGroupEmail = $OldGroupEmail
        NewGroupEmail = $NewGroupEmail
    }
    $Data
}

$GroupList | Export-Csv -Path "C:\Users\ZachThomas\Downloads\Angstrom_Teams.csv" -NoTypeInformation