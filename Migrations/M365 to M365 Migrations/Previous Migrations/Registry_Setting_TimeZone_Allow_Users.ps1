# senske, needs intune config policy

# PowerShell script to change registry settings in Microsoft Intune

# Set time zone automatically
$timezoneRegistryPath = "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\tzautoupdate"
$timezoneRegistryValueName = "Start"

# Change the value data to 3 (Enable Set time zone automatically)
Set-ItemProperty -Path $timezoneRegistryPath -Name $timezoneRegistryValueName -Value 3

# Location setting
$locationRegistryPath = "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location"
$locationRegistryValueName = "Value"

# Change the value string to "Allow" (On)
Set-ItemProperty -Path $locationRegistryPath -Name $locationRegistryValueName -Value "Allow"

# Print a success message
Write-Host "Registry settings updated successfully."
