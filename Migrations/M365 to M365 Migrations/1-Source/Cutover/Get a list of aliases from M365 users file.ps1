# Define the path to the CSV file
$csvPath = "C:\Temp\users_master.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Initialize an empty array to hold the result
$result = @()

foreach ($user in $users) {
    # Check if "#EXT#" is present in the UPN
    if ($user."User principal name" -like "*#EXT#*") {
        continue
    }

    # Extract the UPN
    $upn = $user."User principal name"

    # Extract all addresses and split them into individual entries using the plus sign (+)
    $emailAddresses = $user."Proxy addresses" -split '\+'

    # Loop through each address
    foreach ($email in $emailAddresses) {
        # Strip out the SMTP prefix if it exists, case-insensitive
        $cleanEmail = $email -replace '^(smtp:|SMTP:)', ''

        # Create and add a new object for each address, ensuring one address per line
        $result += [PSCustomObject]@{
            Email          = $upn
            AliasEmail = $cleanEmail
        }
    }
}

# Display the result, which now adheres to the one email address per line requirement
$result | Format-Table -AutoSize

# Optionally, export the result to a new CSV file
$result | Export-Csv -Path "C:\Temp\users_emails_per_line.csv" -NoTypeInformation -Encoding UTF8
