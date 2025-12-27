# =========================================
# 下载文件整理器 - 最终稳定版
# 原文件名 + 下载时间 + 年/月/类型分类
# 跨平台 PowerShell 7
# =========================================

param (
    [switch]$DryRun  # 加上 -DryRun 只预览不移动
)

# -------------------------------
# 下载目录
# -------------------------------
if ($IsWindows) {
    $DownloadPath = Join-Path $HOME "Downloads"
} else {
    $DownloadPath = Join-Path $HOME "Downloads"
}

if (-not (Test-Path $DownloadPath)) {
    Write-Error "下载目录未找到: $DownloadPath"
    exit 1
}

# -------------------------------
# 日志文件
# -------------------------------
$LogFile = Join-Path $DownloadPath "organize.log"

# 非 DryRun 时，覆盖旧日志
if (-not $DryRun) {
    Set-Content $LogFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 日志开始"
}

# -------------------------------
# 文件分类规则
# -------------------------------
$Categories = @{
    "图片"   = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp", ".svg")
    "视频"   = @(".mp4", ".mkv", ".avi", ".mov", ".wmv")
    "文档"   = @(".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".md")
    "压缩包" = @(".zip", ".rar", ".7z", ".tar", ".gz")
    "音频"   = @(".mp3", ".wav", ".flac", ".aac", ".ogg")
    "安装包" = @(".exe", ".msi", ".dmg", ".pkg", ".deb", ".rpm")
}

# -------------------------------
# 排除规则
# -------------------------------
$ExcludeExtensions = @(".crdownload", ".part", ".tmp")

$ExcludeFileNames = @(
    "organize.log"
)

# -------------------------------
# 获取需要整理的文件
# -------------------------------
$Files = Get-ChildItem $DownloadPath -File -Recurse |
    Where-Object {
        # 排除已整理的 年/月 目录
        $_.FullName -notmatch '\\\d{4}\\\d{2}\\'
    } |
    Where-Object {
        # 排除临时下载文件
        -not ($ExcludeExtensions -contains $_.Extension.ToLower())
    } |
    Where-Object {
        # 排除固定文件（日志）
        -not ($ExcludeFileNames -contains $_.Name)
    } 

# -------------------------------
# 开始整理
# -------------------------------
foreach ($File in $Files) {

    try {
        # 双保险：绝不整理日志
        if ($File.Name -eq "organize.log") {
            continue
        }

        $Ext = $File.Extension.ToLower()
        $BaseName = $File.BaseName

        # 已经带时间戳的文件跳过
        if ($BaseName -match "_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}$") {
            continue
        }

        # 时间戳
        $TimeStamp = $File.LastWriteTime.ToString("yyyy-MM-dd_HH-mm-ss")
        $NewBaseName = "{0}_{1}" -f $BaseName, $TimeStamp
        $NewName = "$NewBaseName$Ext"

        # 分类
        $TargetFolder = "其他"
        foreach ($Category in $Categories.GetEnumerator()) {
            if ($Category.Value -contains $Ext) {
                $TargetFolder = $Category.Key
                break
            }
        }

        # 年 / 月 / 类型 目录
        $Year  = $File.LastWriteTime.Year
        $Month = $File.LastWriteTime.ToString("MM")
        $TargetDir = Join-Path $DownloadPath "$Year/$Month/$TargetFolder"

        if (-not (Test-Path $TargetDir)) {
            if ($DryRun) {
                Write-Output "[预览模式] 将创建目录: $TargetDir"
            } else {
                New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
                Add-Content $LogFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 创建目录: $TargetDir"
            }
        }

        # 处理重名冲突
        $TargetPath = Join-Path $TargetDir $NewName
        $Index = 1
        while (Test-Path $TargetPath) {
            $NewName = "{0}_{1}_{2}{3}" -f $BaseName, $TimeStamp, $Index, $Ext
            $TargetPath = Join-Path $TargetDir $NewName
            $Index++
        }

        # 执行或预览
        if ($DryRun) {
            Write-Output "[预览模式] $($File.FullName) -> $TargetPath"
        } else {
            Move-Item $File.FullName $TargetPath
            Write-Output "已整理: $($File.FullName) → $TargetPath"
            Add-Content $LogFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 已整理: $($File.FullName) → $TargetPath"
        }

    } catch {
        Write-Warning "处理文件失败: $($File.FullName)，错误: $_"
        if (-not $DryRun) {
            Add-Content $LogFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 错误: $($File.FullName) - $_"
        }
    }
}

# -------------------------------
# 结束
# -------------------------------
Write-Output "下载文件整理完成。"
if ($DryRun) {
    Write-Output "当前为预览模式，未实际移动任何文件。"
} else {
    Add-Content $LogFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 日志结束"
}
