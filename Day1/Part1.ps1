$in = Get-Content $PSScriptRoot\input.txt | ForEach-Object { $_.Trim() -as [int] }

$prev = $null
$timesIncreased = 0

$in | ForEach-Object { 
    if($null -ne $prev -and $_ -gt $prev) { $timesIncreased++ }
    $prev = $_
}

$timesIncreased