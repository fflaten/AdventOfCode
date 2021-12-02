$in = Get-Content $PSScriptRoot\input.txt
$cCount = $in[0].Length

$rightStep = 3
$downStep = 1

$currentRow = 0
$currentColumn = 0

$trees = 0

do {
    $currentRow += $downStep
    $currentColumn = ($currentColumn+$rightStep)%$cCount

    if($in[$currentRow][$currentColumn] -eq '#') {
        $trees += 1
    }

} until ($currentRow -eq $in.Count-1)

$trees