# Define the directory path, the files should be stored in the following structure:
# Maximum 2 levels of subfolders are supported
# Level-1: Entity: Customer, Vendor, etc.
# Level-2: ID=Primary Key: 10000, 20000, etc.

# "D:\Temp\Customer\10000\Lieferschein16 - Kopie.pdf"
# "D:\Temp\Customer\10000\Lieferschein24321.pdf"
# "D:\Temp\Customer\20000\1221.txt"
# "D:\Temp\Vendor\10000\Lieferschein2344.pdf"

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
    $folderPath = $folder.FullName
    $files = Get-FilesRecursively $folderPath
    $childFolders = $files | ForEach-Object {
        # Split the file path based on backslash ('\') characters and select the second folder
        $_ -split '\\' | Select-Object -Index 1
    } | Sort-Object -Unique

    # Get the relative path of the folder from the base path
    $relativeFolderPath = $folderPath.Replace($basePath, '')

    # Loop through each child folder and add its files to the JSON data
    foreach ($childFolder in $childFolders) {
        $childFiles = $files | Where-Object { $_ -like "*\$childFolder\*" }
        $jsonData["$($relativeFolderPath): $($childFolder)"] = $childFiles
    }
}

# Convert the hashtable to JSON format
$jsonResult = $jsonData | ConvertTo-Json

# Save the JSON object as a JSON file in the root folder of the PowerShell script
$jsonResult | Out-File -FilePath (Join-Path $basePath "beyondcloudconnector.json")
