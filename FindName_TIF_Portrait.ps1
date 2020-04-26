$path = "\\cdcfs\geodata\Strip_Logs\Okmulgee" #target directory

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$StripLog_Name = Get-ChildItem -recurse ($path) -include @("*.*")  | rename-item  -replace {'^[0-9_]+'}




$StripLog_Name