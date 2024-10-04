# Define the path to the CSV file
$csvPath = "C:\Users\TravisCheney\Trusted Tech Team, Irvine\ProServices - Delivery - Clients\BITE Investments\20240520 - 365 Migration\BiteGroups.csv"

# Import the CSV file
$groups = Import-Csv -Path $csvPath

# Initialize an empty array to hold the result
$result = @()

foreach ($group in $groups) {
    # Extract the Group Primary Email
    $primaryEmail = $group."Group primary email"

    # Extract all aliases and split them into individual entries
    # Assuming that the aliases are separated by semicolons (;) or a similar character
    $emailAliases = $group."Group email aliases" -split ';'

    # Loop through each alias
    foreach ($alias in $emailAliases) {
        # Here you don't need to strip SMTP as these are aliases, but you might need to clean or validate them
        $cleanAlias = $alias.Trim()

        # Check if the alias is not empty and does not contain "onmicrosoft.com" before adding it to the result
        if (![string]::IsNullOrEmpty($cleanAlias) -and $cleanAlias -notlike "*onmicrosoft.com*") {
            # Create and add a new object for each alias, ensuring one alias per line
            $result += [PSCustomObject]@{
                GroupEmail = $primaryEmail
                Alias      = $cleanAlias
            }
        }
    }
}

# Display the result, which now adheres to the one alias per line requirement
$result | Format-Table -AutoSize

# Optionally, export the result to a new CSV file
$result | Export-Csv -Path "C:\Temp\group_aliases_per_line.csv" -NoTypeInformation -Encoding UTF8
