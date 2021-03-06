#Create DMO ShortCuts based on File input



$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path
$directorypath = get-Location
$SourcePath = [string]$directorypath 
$ShortCutBasePath = "\\newfield.com\DataHub\Wellfiles\Operated\State-County"
$WorkingFolder = [string]$directorypath 
$SourcePath = $SourcePath.Replace("X:",  $ShortCutBasePath )
$WorkingFolder = $WorkingFolder.Replace("X:", "" )
$APPPATHShctCMD = "c:\Tools\Shortcut.exe"





Function Get-ChildItemToState ($a,$b,$c) {
   
 [String]$Path = $c
 [String]$Filter = "*"
 [Byte]$ToDepth = $a
 [Byte]$CurrentDepth = $b
 
 Get-ChildItem $Path | %{ $_ | 
 ?{ 
        $_.Name -Like $Filter
        $State = $_.Name 
        $FOLDERPATH = $Path +'\' + $State 
        #Write-host $FOLDERPATH 
        Get-ChildItemToCounty 0 1 $FOLDERPATH $State
 
 }
     
    }
}
Function Get-ChildItemToCounty ($a,$b,$FOLDERPATH,$State) {
   
 [String]$Path = $FOLDERPATH
 [String]$Filter = "*"
 [Byte]$ToDepth = $a
 [Byte]$CurrentDepth = $b
 
 Get-ChildItem $Path | %{ $_ | 
 ?{ 
        $_.Name -Like $Filter
        $County = $_.Name 
        $FOLDERPATH = $Path +'\' +  $County 
        #write-host $FOLDERPATH
        #write-host $State ---State
        #Write-host $County ---County
        Get-ChildItemToWell 1 1 $FOLDERPATH $County $State
 
 }
     
    }
}
Function Get-ChildItemToWell ($a,$b,$c,$County,$State) {
   
 [String]$Path = $c
 [String]$Filter = "*"
 [Byte]$ToDepth = $a
 [Byte]$CurrentDepth = $b
 
 Get-ChildItem $Path | %{ $_ | 
 ?{ 
        $_.Name -Like $Filter
        $Wellname = $_.Name 
        $FOLDERPATH = $Path 
        #Write-host $FOLDERPATH 
 
 
 ###################### Write Short Cut Directory
 
  $WellName = $_.Name
                         
 
 $FULLPATH  = $FOLDERPATH + '\' + $WellName 
 $DestinationLOCALPath  =  $FOLDERPATH.Replace("\\newfield.com\DataHub\" ,"c:\_datahub\") +'\'
  if (-not(Test-Path $DestinationLOCALPath )) {
        new-item $DestinationLOCALPath -Type Directory   
    }

 ###################### Write Short Cut
       $DestinationPatharg  =  $DestinationLOCALPath + $WellName +".lnk" 
       $APPPATHShctCMDarg =  " /F:" + """$DestinationPatharg"""  + " /A:C /T:" + """" + $FULLPATH + """"
       
        if (-not(Test-Path $DestinationPatharg )) {
             Start-Process -FilePath 'c:\Tools\Shortcut.exe'  -ArgumentList $APPPATHShctCMDarg  -WorkingDirectory c:\Tools                
          }
          else 
          { Write-host ' ---- Skipped' $DestinationPatharg}
       
       
       
       
                       
#write-host $APPPATHShctCMDarg
#write-host $DestinationPatharg 
#write-host $DestinationLOCALPath 
# write-host $State ----state
# write-host $County ----County
#  write-host $WellName
 
 
 
 
 
 
 
 }
     
    }
}

function Add-Zip
{
    param([string]$zipfilename)

    if(-not (test-path($zipfilename)))
    {
        set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (dir $zipfilename).IsReadOnly = $false  
    }

    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace($zipfilename)

    foreach($file in $input) 
    { 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
    }
}




remove-item c:\_Datahub\Wellfiles\* -recurse -force
Get-ChildItemToState 0 0 $ShortCutBasePath
