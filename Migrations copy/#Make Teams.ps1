#Make Teams
Connect-MicrosoftTeams

$TeamName = "Test"
$MailName = "Test"
$Visibility = "private"

$Team = New-Team -DisplayName $TeamName -MailNickName $MailName -Visibility $Visibility -AllowCreatePrivateChannels $false -AllowUserEditMessages $true -AllowGuestCreateUpdateChannels $false -AllowGuestDeleteChannels $false -AllowDeleteChannels $false
$TeamID = $Team.GroupID

#Function for creating Teams Channels 
function New-TeamChannels {
    param (
        [Parameter(Mandatory = $True)]
        [string]$GroupId,
        [ValidateSet("Yes", "No", IgnoreCase = $true)]
        [string]$Private
    )

    switch ($Private) {
        "Yes" {    
            # Ask for the number of channels to create
            $numberOfChannels = Read-Host -Prompt "Enter the number of Teams channels you want to create"
        
            # Validate input
            if (-not [int]::TryParse($numberOfChannels, [ref]0) -or $numberOfChannels -le 0) {
                Write-Error "Please enter a valid positive number"
                return
            }
        
            # Iterate for the number of channels
            for ($i = 0; $i -lt $numberOfChannels; $i++) {
                # Ask for the name of the channel
                $channelName = Read-Host -Prompt "Enter the name for channel $(($i+1))"
        
                # Validate channel name
                if ([string]::IsNullOrWhiteSpace($channelName)) {
                    Write-Warning "Channel name cannot be empty. Skipping..."
                    continue
                }
        
                New-TeamChannel -GroupId $GroupId -DisplayName $channelName -MembershipType Private
        
                Write-Host "Channel '$channelName' created."
            }
        }
        "No" {
            # Ask for the number of channels to create
            $numberOfChannels = Read-Host -Prompt "Enter the number of Teams channels you want to create"

            # Validate input
            if (-not [int]::TryParse($numberOfChannels, [ref]0) -or $numberOfChannels -le 0) {
                Write-Error "Please enter a valid positive number"
                return
            }

            # Iterate for the number of channels
            for ($i = 0; $i -lt $numberOfChannels; $i++) {
                # Ask for the name of the channel
                $channelName = Read-Host -Prompt "Enter the name for channel $(($i+1))"

                # Validate channel name
                if ([string]::IsNullOrWhiteSpace($channelName)) {
                    Write-Warning "Channel name cannot be empty. Skipping..."
                    continue
                }

                New-TeamChannel -GroupId $GroupId -DisplayName $channelName -MembershipType Standard

                Write-Host "Channel '$channelName' created."
            }
        }
        Default {
            # Ask for the number of channels to create
            $numberOfChannels = Read-Host -Prompt "Enter the number of Teams channels you want to create"

            # Validate input
            if (-not [int]::TryParse($numberOfChannels, [ref]0) -or $numberOfChannels -le 0) {
                Write-Error "Please enter a valid positive number"
                return
            }

            # Iterate for the number of channels
            for ($i = 0; $i -lt $numberOfChannels; $i++) {
                # Ask for the name of the channel
                $channelName = Read-Host -Prompt "Enter the name for channel $(($i+1))"

                # Validate channel name
                if ([string]::IsNullOrWhiteSpace($channelName)) {
                    Write-Warning "Channel name cannot be empty. Skipping..."
                    continue
                }

                New-TeamChannel -GroupId $GroupId -DisplayName $channelName -MembershipType Standard

                Write-Host "Channel '$channelName' created."
            }
        }
    }
}

New-TeamChannels -GroupId $TeamID -Private "Yes"