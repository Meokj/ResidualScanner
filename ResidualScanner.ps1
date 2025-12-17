<#
.SYNOPSIS
ResidualScanner - Scan for leftover software folders on C: drive
.DESCRIPTION
Scans common Windows directories for folders not modified in the last X days (default 180) 
and generates a report, excluding system directories and driver/software support folders.
.PARAMETER Days
Number of days to consider a folder as unused (default: 180)
#>

param(
    [int]$Days = 180
)

# Paths to scan
$scanPaths = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\Users\$env:USERNAME\AppData\Local",
    "C:\Users\$env:USERNAME\AppData\Roaming",
    "$env:TEMP"
)

# Folders to exclude (system + drivers + caches)
$excludeFolders = @(
    "Common Files",
    "Microsoft",
    "Windows",
    "WindowsApps",
    "Windows Mail",
    "ModifiableWindowsApps",
    "Microsoft Update Health Tools",
    "WindowsPowerShell",
    "Windows NT",
    "Intel",
    "AMD",
    "Realtek",
    "Npcap",
    "WinPcap",
    "Temp",
    "Cache",
    "LocalLow"
)

$outputFile = "C:\Residuals_Report.txt"

# Write report header
"Residual scan report - $(Get-Date)" | Out-File $outputFile -Encoding UTF8
"`n===================================" | Out-File $outputFile -Append -Encoding UTF8
Write-Output "Scanning for folders not modified in the last $Days days (excluding system/driver folders)..."

foreach ($path in $scanPaths) {
    if (Test-Path $path) {
        Write-Output "Scanning directory: $path ..."
        
        # Get folders older than $Days and not in exclude list
        $folders = Get-ChildItem $path -Directory -ErrorAction SilentlyContinue | Where-Object {
            ($_.LastWriteTime -lt (Get-Date).AddDays(-$Days)) -and
            ($excludeFolders -notcontains $_.Name)
        }

        foreach ($folder in $folders) {
            $folder.FullName | Out-File $outputFile -Append -Encoding UTF8
        }
    }
}

Write-Output "Scan complete! Results saved to $outputFile"
Write-Output "Please review the report and manually delete leftover folders if necessary."
