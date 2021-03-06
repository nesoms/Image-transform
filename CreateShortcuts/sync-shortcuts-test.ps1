#Create DMO ShortCuts based on File input
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.MyCommand.Path
$directorypath = get-Location
$SourcePath = [string]$directorypath 
$ShortCutBasePath = "\\newfield.com\DataHub\Wellfiles\Operated\State-County\Oklahoma"
$WorkingFolder = [string]$directorypath 
$SourcePath = $SourcePath.Replace("X:",  $ShortCutBasePath )
$WorkingFolder = $WorkingFolder.Replace("X:", "" )
$APPPATHShctCMD = "c:\Tools\Shortcut.exe"





Function Get-ChildItemToDepth {
    Param(
        [String]$Path = $ShortCutBasePath,
        [String]$Filter = "*",
        [Byte]$ToDepth = 2,
        [Byte]$CurrentDepth = 0,
        [Switch]$DebugMode
    )

    $CurrentDepth++
    If ($DebugMode) {
        $DebugPreference = "Continue"
    }

    Get-ChildItem $Path | %{
        $_ | ?{ $_.Name -Like $Filter }



        If ($_.PsIsContainer) {
            If ($CurrentDepth -le $ToDepth) {
            
                # Callback to this function
               Get-ChildItemToDepth -Path $_.FullName -Filter $Filter -ToDepth $ToDepth -CurrentDepth $CurrentDepth 
               
               $Foldername = @($_.FullName | Get-ChildItem -Name)
               $ParentFolder = Get-ChildItem $Path -name
               foreach ($county in $ParentFolder) {
	                   $ParentFolder = Get-ChildItem $Path -name
                       $chkFolderPath = $Path +"\" +  $county
                       $WellNamefolder = Get-ChildItem $chkFolderPath -name      
                                            
                       foreach ($WellName in $WellNamefolder ){
                       if ($WellName -like  '*(*' ) {
                       
                       
                        
                         $FULLPATH  = $chkFolderPath + '\' + $WellName 
                         $DestinationLOCALPath  =  $chkFolderPath.Replace("\\newfield.com\DataHub\" ,"c:\_datahub\") +'\'
                         $DestinationPatharg  =  $chkFolderPath.Replace("\\newfield.com\DataHub\" ,"c:\_datahub\") +'\'+ $WellName +".lnk"
                         
                          if (-not(Test-Path $DestinationLOCALPath )) {
                              new-item $DestinationLOCALPath -Type Directory   
                             }
                         
                         $APPPATHShctCMDarg =  " /F:" + """$DestinationPatharg"""  + " /A:C /T:" + """" + $FULLPATH + """"
                         
                         #Start-Process -FilePath 'c:\Tools\Shortcut.exe'  -ArgumentList $APPPATHShctCMDarg  -WorkingDirectory c:\Tools
                         
                         #write-host $APPPATHShctCMDarg
                       }
                     }
                     
                      
                }
               
               
               
               #write-host '--------------' $Foldername 
            }
            Else {
                Write-Debug $("Skipping GCI for Folder: $($_.FullName) " + `
                  "(Why: Current depth $CurrentDepth vs limit depth $ToDepth)")
            }
        }
    }
}




Get-ChildItemToDepth
