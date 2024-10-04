# Set the path to the directory containing your CSV files
$csvDirectory = "C:\Users\JimCosner\OneDrive - Trusted Tech Team, Irvine\Documents\Clients\McElroy\SharePoint Migration\Logs\Scan Logs"

# Set the path for the combined CSV file
$outputPath = "C:\Users\JimCosner\OneDrive - Trusted Tech Team, Irvine\Documents\Clients\McElroy\SharePoint Migration\Logs\All-With-Success.csv"

# Set the path for the combined CSV file that contains only errors
$errorOutputPath = "C:\Users\JimCosner\OneDrive - Trusted Tech Team, Irvine\Documents\Clients\McElroy\SharePoint Migration\Logs\Only-Errors.csv"

# Get all CSV files in the specified directory
$csvFiles = Get-ChildItem -Path $csvDirectory -Filter *.csv

# Initialize an array to store the combined data
$combinedData = @()

# Loop through each CSV file and import data
foreach ($csvFile in $csvFiles) {
    try {
        $combinedData += Import-Csv $csvFile.FullName
    }
    catch {
        Write-Host "Error processing $($csvFile.FullName): $_"
    }
}

# Check if there is any data to export
if ($combinedData) {
    $combinedData | Export-Csv -Path $outputPath -NoTypeInformation
    Write-Host "Combined CSV file created at: $outputPath"
}
else {
    Write-Host "No data to combine. Check the structure of your CSV files."
}

# Parse through $outputPath CSV and create a new CSV with only items that have a message in the column "ResultCode" to a file called "Only Errors.csv"
$combinedData | Where-Object { $_.ResultCode } | Export-Csv -Path $errorOutputPath  -NoTypeInformation

