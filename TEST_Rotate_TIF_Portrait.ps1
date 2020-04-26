$path = "\\cdcfs\geodata\Strip_Logs" #target directory

[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
Get-ChildItem -recurse ($path) -include @("*.png", "*.tif") |
ForEach-Object {
  $image = [System.Drawing.image]::FromFile( $_ )
  $image.rotateflip("Rotate90FlipNone")
  $image.save($_)
}