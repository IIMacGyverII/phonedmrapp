# Script to add _id column skip logic to ChannelsForm.cs

$filePath = "C:\Users\Joshua\Documents\android\OpenGD77CPS-Mac\DMR\ChannelsForm.cs"
$content = Get-Content $filePath -Raw

# Define the search pattern - the line we want to insert BEFORE
$searchPattern = '						string channelNumStr = cols\[col\+\+\]\.Trim\(\);'

# Define what we want to insert
$insertText = @'
						// Skip _id column if present (new Android format with database ID)
						if (hasIdColumn)
						{
							col++; // Skip the _id column
						}

						// Column 0 (or 1 if _id present): Channel Number (read but use sequential assignment)
						
'@

# Check if the modification has already been made
if ($content -match 'Skip _id column if present') {
    Write-Host "Modification already exists in the file. Skipping." -ForegroundColor Yellow
    exit 0
}

# Perform the replacement
$newContent = $content -replace $searchPattern, ($insertText + 'string channelNumStr = cols[col++].Trim();')

if ($content -eq $newContent) {
    Write-Host "Error: Pattern not found or replacement failed!" -ForegroundColor Red
    Write-Host "Searching for pattern: $searchPattern"
    exit 1
}

# Backup the original file
$backupPath = $filePath + ".backup"
Copy-Item $filePath $backupPath -Force
Write-Host "Created backup at: $backupPath" -ForegroundColor Green

# Write the modified content
Set-Content $filePath $newContent -NoNewline
Write-Host "Successfully modified $filePath" -ForegroundColor Green
Write-Host "Added _id column skip logic before channelNumStr line" -ForegroundColor Green
