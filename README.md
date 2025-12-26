# ResidualScanner

<hr>

* 1.原文件名 + 下载时间
* 2.防止重复时间戳
* 3.分类整理（Images / Videos / Documents / Archives / Audio / Installers / Others）
* 4.排除未完成下载文件（.crdownload / .part / .tmp）
* 5.Dry-run 预览模式
* 6.年/月/类型三级目录
* 7.日志记录
* 8.错误不中断
* 
## 执行

* 执行模式
```powershell
# 判断系统
if ($IsWindows) {
    # 中文 Windows
    $DownloadDir = Join-Path $HOME "下载"
} else {
    $DownloadDir = Join-Path $HOME "Downloads"
}

# 脚本保存目录
$ScriptDir = Join-Path $DownloadDir "scripts"

# 创建目录
if (-not (Test-Path $ScriptDir)) {
    New-Item -ItemType Directory -Path $ScriptDir -Force | Out-Null
}

$LocalPath = Join-Path $ScriptDir "organize-downloads.ps1"

# 下载脚本
$Url = "https://raw.githubusercontent.com/Meokj/ResidualScanner/main/organize-downloads.ps1"
irm $Url -OutFile $LocalPath
```

* 预览模式
```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/organize-downloads.ps1
$ScriptBlock = [ScriptBlock]::Create($Script)
& $ScriptBlock -DryRun
```
