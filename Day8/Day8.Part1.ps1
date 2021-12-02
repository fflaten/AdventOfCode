$instructions = switch -Regex -File "$PSScriptRoot\input.txt" {
    '(\w+) (-|\+)(\d+)' {
        [PSCustomObject]@{
            Op = $Matches[1]
            Negate = $Matches[2] -eq '-'
            Number = $Matches[3] -as [int]
            Executed = $false
        }
    }
    default { Write-Warning "Uncaught instruction pattern: $_" }
}

$accumulator = 0

:outerLoop for($i=0; $i -lt $instructions.Count; $i++) {
    $inst = $instructions[$i]
    "Processing instruction $i $($inst.Op)"
    if($inst.Executed) { "Instruction has previously been executed. Aborting. Accumulator is $accumulator"; break }

    switch ($inst.Op) {
        'nop' { Write-Warning "NOP found. Skipping"; continue outerLoop }
        'acc' {
            if($inst.Negate) {
                $accumulator -= $inst.Number
            } else {
                $accumulator += $inst.Number
            }
        }
        'jmp' {
            if($inst.Negate) {
                #Write-Warning "jmp $($inst.Negate ? "-" : "+") $($inst.Number) to $($i-($inst.number+1))"
                $i -= ($inst.Number+1)
            } else {
                #Write-Warning "jmp $($inst.Negate ? "-" : "+") $($inst.Number) to $($i+($inst.number-1))"
                $i += ($inst.Number-1)
            }
         }
    }

    $inst.Executed = $true
}