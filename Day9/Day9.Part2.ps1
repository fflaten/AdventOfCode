$xmas = Get-Content "$PSScriptRoot\input.txt" | ForEach-Object { $_.Trim() -as [int64] }
$preamble = 25

for ($i=$preamble; $i -lt $xmas.Count; $i++) {
    $invalidNumber = $xmas[$i]
    $valuesToTest = $xmas[($i-$preamble)..($i-1)]
    $isASum = $false

    :outerLoop foreach($left in $valuesToTest) {
        foreach($right in $valuesToTest) {
            if($left -ne $right -and ($left+$right -eq $invalidNumber)) {
                $isASum = $true
                break outerLoop
            }
        }
    }

    if($isASum -eq $false) {
        "Unique value found: $invalidNumber. Moving on to finding contiguous set of numbers that has this as sum"
        break
    }
}

$sum = 0
$contiguousNumbers = New-Object System.Collections.ArrayList
$success = $false

for ($i=0; $i -lt $xmas.Count; $i++) {
    $contiguousNumbers.Clear()
    $contiguousNumbers.Add($xmas[$i]) > $null
    $sum = $xmas[$i]
    $a = $i

    while ($sum -lt $invalidNumber) {
        $nextValue = $xmas[$a++]
        $contiguousNumbers.Add($nextValue) > $null
        $sum+=$nextValue
        #Write-Host "a: $a - nextValue: $nextValue - sum: $sum"
    }

    if($sum -eq $invalidNumber -and $contiguousNumbers.Count -ge 2) {
        $success = $true
        break
    }
    #"Sum too large. i: $i - a: $a - sum: $sum - contiguousNumbers count: $($contiguousNumbers.Count). Skipping to next i-value. "
}

if($success) {
    ,($contiguousNumbers | Sort-Object) | ForEach-Object { 
        "Encryption weakness: $($_[0]) + $($_[-1]) = $($_[0] + $_[-1])"
    }
} else {
    "No contiguous numbers found that match $invalidNumber"
}