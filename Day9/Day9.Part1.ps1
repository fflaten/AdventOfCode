$xmas = Get-Content $PSScriptRoot\input.txt | ForEach-Object { $_.Trim() -as [int64] }

$preamble = 25

for ($i=$preamble; $i -lt $xmas.Count; $i++) {
    $currentValue = $xmas[$i]
    $valuesToTest = $xmas[($i-$preamble)..($i-1)]
    $isASum = $false

    :outerLoop foreach($left in $valuesToTest) {
        foreach($right in $valuesToTest) {
            if($left -ne $right -and ($left+$right -eq $currentValue)) {
                $isASum = $true
                break outerLoop
            }
        }
    }

    if($isASum -eq $false) {
        "Unique value found: $currentValue"
        break
    }
}