$in = Get-Content "$PSScriptRoot\input.txt"

$hPos, $depth, $aim = 0, 0, 0

foreach ($instruction in $in) {
    $action, $value = $instruction.Split(' ')
    switch ($action) {
        'up' { $aim -= $value }
        'down' { $aim += $value }
        'forward' { 
            $hPos += $value
            $depth += $aim * $value
        }
        Default { Write-Error "Uncaught switch condition! '$_'" }
    }
}

"Result: $hPos (hPos) * $depth (depth) = $($hPos*$depth)"