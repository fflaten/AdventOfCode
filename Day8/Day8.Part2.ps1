$instructions = switch -Regex -File "$PSScriptRoot\input.txt" {
    '(\w+) (-|\+)(\d+)' {
        [PSCustomObject]@{
            Op = $Matches[1]
            Negate = $Matches[2] -eq '-'
            Number = $Matches[3] -as [int]
        }
    }
    default { Write-Warning "Uncaught instruction pattern: $_" }
}

function ExecuteInstructions ($instructionsToExecute, $instructionToFlip) {
    $accumulator = 0
    $callHistory = @{}
    
    :outerLoop for($i=0; $i -lt $instructionsToExecute.Count; $i++) {
        $inst = $instructionsToExecute[$i]
        if($callHistory.ContainsKey($i)) {
            #"Instruction has previously been executed. Aborting. Accumulator is $accumulator"; break
            return 1
        }

        $OpCode = $i -eq $instructionToFlip ? ($inst.Op -eq 'jmp' ? 'nop':'jmp'):$inst.Op
    
        switch ($OpCode) {
            'nop' { continue outerLoop }
            'acc' {
                if($inst.Negate) {
                    $accumulator -= $inst.Number
                } else {
                    $accumulator += $inst.Number
                }
            }
            'jmp' {
                if($inst.Negate) {
                    $i -= ($inst.Number+1)
                } else {
                    $i += ($inst.Number-1)
                }
             }
        }
    
        $callHistory[$i] += 1
    }

    Write-Host "Finished successfully when flipping $instructionToFlip. Accumulator is: $accumulator"
}

# Mutate program until it works
for($i=0; $i -lt $instructions.Count; $i++) {
    if($instructions[$i].Op -ne 'acc') {
        $ret = ExecuteInstructions -instructionsToExecute $instructions -instructionToFlip $i
        if($ret -ne 1) { break }
    }
}