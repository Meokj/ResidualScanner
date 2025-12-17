<#
.SYNOPSIS
ResidualScanner - Scan for leftover software folders on C: drive
.DESCRIPTION
Scans common Windows directories for folders not modified in the last X days (default 180) 
and generates a report, excluding system directories, driver/software support folders,
and checks registry for uninstalled software accurately.
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
    "Microsoft.NET",
    "Windows Photo Viewer",
    "Npcap",
    "WinPcap",
    "Temp",
    "Cache",
    "LocalLow",
    "Google",
    "Mozilla",
    "Edge"
)

$outputFile = "C:\Residuals_Report.txt"

# Function: Check if folder corresponds to installed software in registry
function Test-IsResidual {
    param (
        [string]$FolderPath
    )

    $folderName = [System.IO.Path]::GetFileName($FolderPath).ToLower()
    $uninstallPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($regPath in $uninstallPaths) {
        if (Test-Path $regPath) {
            Get-ChildItem $regPath | ForEach-Object {
                $props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
                $installLocation = $props.InstallLocation
                $displayName = $props.DisplayName

                if ($installLocation -and ($FolderPath.ToLower() -like ($installLocation.ToLower() + "*"))) {
                    return $false
                }

                if ($displayName -and ($folderName -like ("*" + $displayName.ToLower() + "*"))) {
                    return $false
                }
            }
        }
    }

    return $true 
}

# Write report header
"Residual scan report - $(Get-Date)" | Out-File $outputFile -Encoding UTF8
"`n===================================" | Out-File $outputFile -Append -Encoding UTF8
Write-Output "Scanning for folders not modified in the last $Days days (excluding system/driver folders and checking registry)..."

foreach ($path in $scanPaths) {
    if (Test-Path $path) {
        Write-Output "Scanning directory: $path ..."

        # Get folders older than $Days and not in exclude list
        $folders = Get-ChildItem $path -Directory -ErrorAction SilentlyContinue | Where-Object {
            ($_.LastWriteTime -lt (Get-Date).AddDays(-$Days)) -and
            ($excludeFolders -notcontains $_.Name)
        }

        foreach ($folder in $folders) {
            # Only output if software is uninstalled
            if (Test-IsResidual -FolderPath $folder.FullName) {
                $folder.FullName | Out-File $outputFile -Append -Encoding UTF8
            }
        }
    }
}

Write-Output "Scan complete! Results saved to $outputFile"
Write-Output "Please review the report and manually delete leftover folders if necessary."
