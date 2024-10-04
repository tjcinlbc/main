# PowerShell Script to Import CSV and Send Emails with Credentials using Exchange Online (Office 365) SMTP Authentication

# Define the path to the CSV file and SMTP settings
$csvPath = "C:\Users\TravisCheney\Downloads\users_7_18_2024 8_11_06 PM.csv" # Update this path to your CSV file location
$smtpServer = "smtp.office365.com" # Office 365 SMTP server
$smtpPort = 587 # TLS port for Office 365
$smtpUser = "AdeleV@M365x91325595.OnMicrosoft.com" # Your Office 365 email address
$smtpPassword = "*30Roxanne18" # Your Office 365 password
$fromEmail = $smtpUser # Sender email, same as your Office 365 email
$subject = "Your New Credentials Post Migration"

# Securely storing the password
$securePassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force

# Creating a credential object
$smtpCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $smtpUser, $securePassword

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV
foreach ($user in $users) {
	$toEmail = $user."Source - UPN" # Extracting the "Source - UPN" as the email address
	$body = @"
Hello,

Your new details are as follows:
New UPN: $($user."Destination - Post Migration UPN")
Password: $($user.Password)

Please do not share your credentials with anyone.

Thank you,
Your IT Team
"@

	# Send the email using Office 365 SMTP server
	Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $smtpCredential -From $fromEmail -To $toEmail -Subject $subject -Body $body
}