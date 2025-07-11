#MultCo Land Use Copy & Validate
$files = Get-ChildItem -Path "path\to\files"
$whitelist = @('')
$startTime = Get-Date
$i = 1
foreach($file in $files) {
  $elapsed = ((Get-Date) - $startTime).TotalSeconds
  $remains = $files.Count - $i
  $avgTime = $elapsed / $i
  $tgt = $file.FullName.SubString("path\to\files\before\box\number")
  Write-Progress -Activity "Copy & Validate" -Status "$i of $($files.Count)" -PercentComplete (($i/$files.Count)*100) -SecondsRemaining ($remains * $avgTime) -CurrentOperation $tgt
  $box = $tgt.substring(0,5) # All box names for this contract were 5 chars in length
  if(!($whitelist -contains $box) { # ! operand because I intend to make this a blacklist later.
    Write-Output "$box not in whitelist, skipping..."
  } else {
    $preHash = Get-FileHash $file.FullName
    New-Item -ItemType File -Path "D:\$tgt" -Force | Out-Null
    Copy-Item -Path $file.FullName -Destination "D:\$tgt" -Force
    if ($preHash.Hash -ne $postHash.Hash) {
      Write-Warning "COPY FAIL: $file"
      Remove-Item -Path "D:\$tgt"
    }
  }
  $i++
}
