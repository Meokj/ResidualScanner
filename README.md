# ResidualScanner

* 自动排除系统目录（Windows、Microsoft、.NET、WindowsPowerShell 等）

* 排除驱动和核心工具目录（Intel、AMD、Realtek、Npcap、WinPcap 等）

* 排除 AppData 的系统缓存、浏览器缓存、临时文件夹（LocalLow、Temp、Cache 等）

* 检查注册表，只有已卸载的软件文件夹才列为残留

* 支持自定义未修改天数（默认 180 天）

* 输出报告清晰，只显示可能需要手动清理的残留文件夹

```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/ResidualScanner.ps1
& ([ScriptBlock]::Create($Script)) -Days 180
```
