$dedupVolume = "D:"
 
Set-DedupVolume -Volume $dedupVolume -MinimumFileAgeDays 0
 
Write-Output "Starting Dedup Jobs..."
$j = Start-DedupJob -Type Optimization -Volume $dedupVolume -Memory 75 -Cores 90 -Priority High
$j = Start-DedupJob -Type GarbageCollection -Volume $dedupVolume
$j = Start-DedupJob -Type Scrubbing -Volume $dedupVolume
 
do {
    Write-Output "Them Dedup jobs is running.  Status:"
    $state = Get-DedupJob | Sort-Object StartTime -Descending 
    $state | ft
    if ($state -eq $null) { Write-Output "Completing, please wait..." }
    sleep -s 5
} while ($state -ne $null)
 
#cls
Write-Output "Done DeDuping"
Get-DedupStatus | fl *
