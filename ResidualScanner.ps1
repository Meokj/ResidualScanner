# Scan-CResiduals-EN.ps1
# Function: Scan common software leftover folders on C: drive
# All prompts in English to avoid encoding issues

# Paths to scan
$scanPaths = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\Users\$env:USERNAME\AppData\Local",
    "C:\Users\$env:USERNAME\AppData\Roaming",
    "$env:TEMP"
)

# Output file
$outputFile = "C:\Residuals_Report.txt"

# Write report header
"Software leftover scan report - $(Get-Date)" | Out-File $outputFile -Encoding UTF8
"`n===================================" | Out-File $outputFile -Append -Encoding UTF8

foreach ($path in $scanPaths) {
    if (Test-Path $path) {
        Write-Output "Scanning directory: $path ..."
        # Find folders not modified in the last 180 days (possible leftovers)
        $folders = Get-ChildItem $path -Directory -ErrorAction SilentlyContinue | Where-Object {
            ($_.LastWriteTime -lt (Get-Date).AddDays(-180))
        }

        foreach ($folder in $folders) {
            $folder.FullName | Out-File $outputFile -Append -Encoding UTF8
        }
    }
}

Write-Output "Scan complete! Results saved to $outputFile"
Write-Output "Please review the report and manually delete leftover folders if necessary."
