$image = "C:\TEMP\Strip_Logs\A SNIDER 1-0024.tif"

#Load required assemblies and get object reference 
[Reflection.Assembly]::LoadWithPartialName(“System.Windows.Forms”); 
$i = new-object System.Drawing.Bitmap(“C:\TEMP\Strip_Logs\A SNIDER 1-0024.tif”); 
#Display image properties including height and width 
$i; 
#Play with the image 
$i.rotateflip(“Rotate90FlipNone”); 
#Save with the image in the desired format 
$i.Save(“C:\TEMP\Strip_Logs\A SNIDER 1-0024-XO.tif”,“TIF”); 