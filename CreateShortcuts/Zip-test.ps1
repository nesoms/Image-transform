


 

Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"

$currentDate = Get-Date;
$currentDate | Get-Member -Membertype Method Add;
$daysBefore = -1;
$archiveTillDate = $currentDate.AddDays($daysBefore);

$sourcePath = 'C:\_datahub';
$destPath='c:\_datahub\Wellfiles.zip';

$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal;
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourcePath,$destPath, $compressionLevel, $false);
 