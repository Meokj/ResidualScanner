param(
    [int]$Days = 180
)

$scanPaths = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "C:\Users\$env:USERNAME\AppData\Local",
    "C:\Users\$env:USERNAME\AppData\Roaming",
    "$env:TEMP"
)

# 排除系统文件夹和常见缓存
$excludeFolders = @(
    "Common Files","Microsoft","Windows","WindowsApps","Windows Mail",
    "ModifiableWindowsApps","Microsoft.NET","Temp","Cache","LocalLow"
)

$outputFile = "C:\Residuals_Report.txt"

"Residual scan report - $(Get-Date)" | Out-File $outputFile -Encoding UTF8
"`n===================================" | Out-File $outputFile -Append -Encoding UTF8
Write-Output "Scanning for folders not modified in the last $Days days..."

foreach ($path in $scanPaths) {
    if (Test-Path $path) {
        Write-Output "Scanning directory: $path ..."
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
