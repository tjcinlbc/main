# Install the ExchangeOnlineManagement module if not already installed
# Install-Module -Name ExchangeOnlineManagement

# Import the ExchangeOnlineManagement module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline 

# Import the CSV file
$csv = Import-Csv -Path "C:\temp\DistributionGroupMembersAndOwnersWithExternalEmails1.csv"

# Loop through each row in the CSV
foreach ($row in $csv) {
	$distributionGroupEmail = $row.'distribution group email'
	$personEmail = $row.'Person Email'

	# Add the person email to the distribution group
	Add-DistributionGroupMember -Identity $distributionGroupEmail -Member $personEmail
}

# Disconnect from Exchange Online
