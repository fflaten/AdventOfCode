$in = Get-Content $PSScriptRoot\input.txt
$cCount = $in[0].Length

$Rounds = @(1,1),@(3,1),@(5,1),@(7,1),@(1,2)
$foundTrees = @()

foreach ($round in $Rounds) {
    $rightStep, $downStep = $round
    $trees = $currentRow = $currentColumn = 0

    do {
        $currentRow += $downStep
        $currentColumn = ($currentColumn+$rightStep)%$cCount
    
        if($in[$currentRow][$currentColumn] -eq '#') {
            $trees += 1
        }
    
    } until ($currentRow -eq $in.Count-1)

    $foundTrees += $trees
}

$t = $null; $foundTrees | % { if($t -eq $null) { $t = $_ } else { $t = $t*$_ } }
"$($foundTrees -join ' * ') = $t"