# ResidualScanner

* 原文件名 + 下载时间

* 防止重复时间戳

* 分类整理（Images / Videos / Documents / Archives / Audio / Installers / Others）

* 排除未完成下载文件（.crdownload / .part / .tmp）

* Dry-run 预览模式

* 年/月/类型三级目录

* 日志记录

* 错误不中断

```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/organize-downloads.ps1
& ([ScriptBlock]::Create($Script))
```

```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/organize-downloads.ps1
$ScriptBlock = [ScriptBlock]::Create($Script)
& $ScriptBlock -DryRun
```
