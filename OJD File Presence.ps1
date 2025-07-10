# This contract required a specific number of files per folder, named either "Contract Documents", "Correspondence", or "Other".
# This script confirms that there are 3 files and all files are one of the names.

$PSStyle.Progress.View = "Classic"
$Dirs = Get-ChildItem -Attribute Directory -Path "path\to\dirs"
$i = 1
$num = 0

foreach ($Dir in $Dirs) {
  Write-Progress -Id 0 -Activity "Validating File Presence" -CurrentOperation $Dir.Name -Status "$i of $($Dirs.Count)" -PercentComplete (($i/$Dirs.Count)*100)
  $j = 1
  $Files = Get-ChildItem -Path $Dir
  if ($Files.Count -ne 3) {
    if ($Files.Count -eq 0) {
      Write-Output "Empty folder: $dir"
    } else {
      Write-Warning "Bad Folder (Count $($Files.Count)): $dir"
      $num ++
    }
  }
  foreach ($File in $Files) {
    Write-Progress -Id 1 -ParentId 0 -Activity "Confirming File Names" -CurrentOperation $File.Name "$j of $($Files.Count)" -PercentComplete (($j/$Files.Count)*100)
    if (!$File.Name.Contains("Contract Documents", "InvariantCultureIgnoreCase") -and !$File.Name.Contains("Correspondence", "InvariantCultureIgnoreCase") -and !$File.Name.Contains("Other", "InvariantCultureIgnoreCase")) {
      Write-Warning "Bad File Name: $File"
      $num++
    }
    $j++
  }
  $i++
}
$out = "no bad items"
if ($num -gt 0) {
  $out = "$num bad items found"
}
Write-Output $out
