$in = Get-Content $PSScriptRoot\input-part1.txt

$timesIncreased = 0
$prev = $null

for($i=0;$i+2 -lt $in.Count;$i++) {
    $sum = ($in[$i..($i+2)] | Measure-Object -Sum).Sum
    if($null -ne $prev -and $sum -gt $prev) { $timesIncreased++ }
    $prev = $sum
}

$timesIncreased