# Install-Module -Name ExchangeOnlineManagement -Force
Connect-ExchangeOnline

#Constant Variables
$OutputFile = "c:\temp\GroupMembersAndOwnersWithPrivacy.csv" #The CSV Output file that is created, change for your purposes

#Prepare Output file with headers
Out-File -FilePath $OutputFile -InputObject "Group DisplayName,Group Email,AllowExternalEmails,Privacy,TeamsEnabled,Person DisplayName, Person Email, Role" -Encoding UTF8

#Get all Microsoft 365 Groups from Office 365
$objGroups = Get-UnifiedGroup -ResultSize Unlimited

#Iterate through all groups, one at a time
Foreach ($objGroup in $objGroups)
{
    $AllowExternalEmails = -not $objGroup.RequireSenderAuthenticationEnabled
    $Privacy = $objGroup.AccessType
    # TeamsEnabled check is more complex without direct Teams module integration; this is a placeholder
    # for logic that would typically involve checking Teams existence via Graph API or Teams PowerShell module.

    write-host "Processing $($objGroup.DisplayName)..."

    # Process owners
    $objGroupOwners = Get-UnifiedGroupLinks -Identity $($objGroup.PrimarySmtpAddress) -LinkType Owners
    write-host "Found $($objGroupOwners.Count) owners..."
    Foreach ($objOwner in $objGroupOwners)
    {
        $ownerDetails = Get-Mailbox -Identity $objOwner.PrimarySmtpAddress
        Out-File -FilePath $OutputFile -InputObject "$($objGroup.DisplayName),$($objGroup.PrimarySMTPAddress),$AllowExternalEmails,$Privacy,'CheckManually',$($ownerDetails.DisplayName),$($ownerDetails.PrimarySMTPAddress),Owner" -Encoding UTF8 -append
    }

    # Process members
    $objGroupMembers = Get-UnifiedGroupLinks -Identity $($objGroup.PrimarySmtpAddress) -LinkType Members
    write-host "Found $($objGroupMembers.Count) members..."
    Foreach ($objMember in $objGroupMembers)
    {
        $memberDetails = Get-Mailbox -Identity $objMember.PrimarySmtpAddress
        Out-File -FilePath $OutputFile -InputObject "$($objGroup.DisplayName),$($objGroup.PrimarySMTPAddress),$AllowExternalEmails,$Privacy,'CheckManually',$($memberDetails.DisplayName),$($memberDetails.PrimarySMTPAddress),Member" -Encoding UTF8 -append
    }
}
