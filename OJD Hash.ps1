# This was literally my first powershell script. I built it to make sure that the items I copied from a local disk to an external harddisk are valid before they get driven halfway across the state on a disk of rust.

$PSStyle.Progress.View = "Classic"
$Files = Get-ChildItem ".\*.pdf" -Recurse
$Max = $Files.Count
$i = 1
$Num = 0

foreach ($File in $Files) {
  $Tgt = $File.FullName.IndexOf("Contract Files"))
  $Progress = ($i/$Max) * 100
  Write-Progress -Activity "Verifying Copy" -Status "$i of $Max" -CurrentOperation $Tgt -PercentComplete $Progress
  $PreHash = Get-FileHash $File.FullName
  $PostHash = Get-FileHash "D:\$Tgt"
  if ($PreHash.Hash -ne $PostHash.Hash) {
    Write-Warning "Hash mismatch: $tgt"
    $Num++
  }
  $i++
}
Write-Host $Num copies failed"
