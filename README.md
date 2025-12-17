# ResidualScanner
* powershell管理员身份运行
```powershell
$Script = irm https://raw.githubusercontent.com/Meokj/ResidualScanner/main/ResidualScanner.ps1
& ([ScriptBlock]::Create($Script)) -Days 180
```
