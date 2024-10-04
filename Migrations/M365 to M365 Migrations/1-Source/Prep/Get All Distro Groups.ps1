# Install-Module -Name ExchangeOnlineManagement -Force
Connect-ExchangeOnline

#Constant Variables
$OutputFile = "c:\temp\DistributionGroupMembersAndOwnersWithExternalEmails1.csv" #The CSV Output file that is created, change for your purposes

#Prepare Output file with headers
Out-File -FilePath $OutputFile -InputObject "Distribution Group DisplayName,Distribution Group Email,Person DisplayName, Person Email, Role, AllowExternalEmails" -Encoding UTF8

#Get all Distribution Groups from Office 365
$objDistributionGroups = Get-DistributionGroup -ResultSize Unlimited

#Iterate through all groups, one at a time
Foreach ($objDistributionGroup in $objDistributionGroups)
{
    $AllowExternalEmails = -not $objDistributionGroup.RequireSenderAuthenticationEnabled
    write-host "Processing $($objDistributionGroup.DisplayName)..."

    #Iterate through each owner in the ManagedBy property
    Foreach ($owner in $objDistributionGroup.ManagedBy)
    {
        $ownerDetails = Get-Recipient -Identity $owner
        Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($ownerDetails.DisplayName),$($ownerDetails.PrimarySMTPAddress),Owner,$AllowExternalEmails" -Encoding UTF8 -append
        write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($ownerDetails.DisplayName),$($ownerDetails.PrimarySMTPAddress),Owner,$AllowExternalEmails"
    }

    #Get members of this group
    $objDGMembers = Get-DistributionGroupMember -Identity $($objDistributionGroup.PrimarySmtpAddress)
    write-host "Found $($objDGMembers.Count) members..."
    
    #Iterate through each member
    Foreach ($objMember in $objDGMembers)
    {
        Out-File -FilePath $OutputFile -InputObject "$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),Member,$AllowExternalEmails" -Encoding UTF8 -append
        write-host "`t$($objDistributionGroup.DisplayName),$($objDistributionGroup.PrimarySMTPAddress),$($objMember.DisplayName),$($objMember.PrimarySMTPAddress),Member,$AllowExternalEmails"
    }
}
