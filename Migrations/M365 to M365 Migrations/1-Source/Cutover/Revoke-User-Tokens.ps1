# Ensure you have the AzureAD module installed
# Install-Module -Name AzureAD

# Connect to Azure AD with an account that has the necessary permissions
Connect-AzureAD

# Path to the CSV file
$csvFilePath = "C:\Users\TravisCheney\Downloads\CorpConc users_9_27_2024 9_59_50 PM.csv"

# Import user UPNs from the CSV file
$userPrincipalNames = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty "User principal name"

# Loop through each UPN and revoke the refresh tokens
foreach ($upn in $userPrincipalNames) {
    # Skip if the user name starts with cspadmin
    if ($upn -like "cspadmin*") {
        Write-Output "Skipping user: $upn"
        continue
    }
    # Skip if the username starts with migrationwiz
    if ($upn -like "FlySA*") {
        Write-Output "Skipping user: $upn"
        continue
    }
    # Skip if the user is external
    if ($upn -like "*#EXT#*") {
        Write-Output "Skipping external user: $upn"
        continue
    }
        # Skip if the user is external
        if ($upn -like "*Elliot*") {
            Write-Output "Skipping external user: $upn"
            continue
        }
        # Skip if the user is external
        if ($upn -like "*Administrator*") {
            Write-Output "Skipping external user: $upn"
            continue
        }
        # Skip if the user is external
        if ($upn -like "*admin*") {
            Write-Output "Skipping external user: $upn"
            continue
        }
        
    try {
        # Revoke the user's refresh tokens
        Revoke-AzureADUserAllRefreshToken -ObjectId (Get-AzureADUser -Filter "UserPrincipalName eq '$upn'").ObjectId
        Write-Output "Refresh tokens revoked for user: $upn"
    } catch {
        Write-Error "Failed to revoke refresh tokens for user: $upn. Error: $_"
    }
}
