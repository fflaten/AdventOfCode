$in = Get-Content "$PSScriptRoot\input.txt"

$hPos = $depth = 0

foreach ($instruction in $in) {
    $action, $value = -split $instruction
    switch ($action) {
        'forward' { $hPos += $value }
        'up' { $depth -= $value }
        'down' { $depth += $value }
        Default { Write-Error "Uncaught switch condition! '$_'" }
    }
}

"Result: $hPos (hPos) * $depth (depth) = $($hPos*$depth)"