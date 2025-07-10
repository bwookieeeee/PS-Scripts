# A contract required that pages greater than 11" x 17" be scanned as multipage TIF files at 600 DPI, billed by the square footage. Stores it in a CSV that can be imported to excel for billing.

[System.Reflection.Assembly]::LoadWithParitalName("System.Drawing")

$Tifs = Get-ChildItem -Path "path\to\tifs"
$i = 1
$Total = $Tifs.Count

foreach ($Tif in $Tifs) { 
  Write-Progress -Activity "Getting Oversize Dimensions..." -Status "$i of $Total" -PercentComplete $(($i/$Total) * 100)
  $Target = [System.Drawing.Bitmap]::FromFile($Tif.FullName)
  $Box = Split-Path -Path $(Split-Path -Path $Tif -Parent) -Leaf
  $File = $Tif.BaseName
  $Date = $Tif.CreationTime
  $Count = $Target.GetFrameCount([System.Drawing.Imaging.FrameDimension]::Page)
  $Width = $Target.Width / 600
  $Height = $Target.Height / 600
  $Area = ($Width * $Height * $Count) / 144
  $Data = [PSCustomObject]@{
    Box    = $Box
    File   = $File
    Date   = $Date
    Count  = $Count
    Width  = $Width
    Height = $Height
    Area   = $Area
  }
  $Data | Export-Csv -Path "path\to\save\tifs.csv" -Append
  $i++
}
