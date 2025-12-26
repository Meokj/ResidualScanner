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
$LocalPath = Join-Path $HOME "下载\organize-downloads.ps1" 
# $LocalPath = Join-Path $HOME "Downloads/organize-downloads.ps1"
irm $Url -OutFile $LocalPath
```

* 预览模式
```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/organize-downloads.ps1
$ScriptBlock = [ScriptBlock]::Create($Script)
& $ScriptBlock -DryRun
```
