# Define the directory path, the files should be stored in the following structure:
# Maximum 1 level of subfolders are supported
# Level-1: Entity with ID=Primary Key: Customer 10000, Vendor 20000, etc.
# "D:\Temp\Customer 10000\Lieferschein16 - Kopie.pdf"
# "D:\Temp\Customer 10000\Lieferschein24321.pdf"
# "D:\Temp\Customer 20000\1221.txt"
# "D:\Temp\Vendor 10000\Lieferschein2344.pdf"

$basePath = "D:\Temp\"

# Initialize an empty hashtable to store the data
$jsonData = @{}

# Function to get the files in a folder and its subfolders
function Get-FilesRecursively {
    param (
        [string]$FolderPath
    )

    Get-ChildItem -Path $FolderPath -Recurse -File | ForEach-Object {
        $_.FullName.Replace($basePath, '')
    }
}

# Get all subfolders under the base path
$subfolders = Get-ChildItem -Path $basePath -Directory

# Loop through each subfolder and process its contents
foreach ($folder in $subfolders) {
    $folderName = $folder.Name       
    $formattedFolderName = "$($folderName -split ' ' | Select-Object -Index 0): $($folderName -split ' ' | Select-Object -Index 1)"
    $files = Get-FilesRecursively $folder.FullName

    # If there are multiple files, create an array of file paths
    $jsonData[$formattedFolderName] = $files
}

# Convert the hashtable to JSON format
$jsonResult = $jsonData | ConvertTo-Json

# Save the JSON object as a JSON file in the root folder of the PowerShell script
$jsonResult | Out-File -FilePath (Join-Path $basePath "beyondcloudconnector.json")
