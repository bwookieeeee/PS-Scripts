# Copy PDF files from a local directory to an external harddisk for delivery to OJD

$InDir = "Some\Path\To\Store"
$OutDir = "D:\"
$EntryPoint = "Contract Files"
$Files = Get-ChildItem "$InDir\*.pdf" -Recurse
$i = 1

foreach( $File in $Files ) {
  $Target = $File.FullName.Substring($File.FullName.IndexOf($Entry Point))
  Write-Progress -Activity "Copy & Validate" -Status "$i of $($Files.Count)" -CurrentOperation $Target -PercentComplete (($i/$Files.Count)*100)
  $Attempt = 1
  $DidCopy = $False
  while (!$DidCopy -and ($Attempt -le 3)) {
    $PreHash = Get-FileHash $File.FullName
    New-Item -ItemType file -Path "$OutDir$Target" -Force
    Copy-Item -Path $File.FullName -Destination "$OutDir$Target"
    $PostHash = Get-FileHash $OutDir$Target
    if ($PreHash.Hash -eq $PostHash.Hash) {
      $DidCopy = $True
    } else {
      Write-Warning "(attempt $Attempt) copy fail: $target"
      $Attempt ++
    }
  }
  $i ++
}
