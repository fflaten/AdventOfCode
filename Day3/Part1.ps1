$in = Get-Content "$PSScriptRoot\input.txt"

# Gamma rate in binary = Most popular char per index
# Epsilon rate in binary = Least popular char per index
$gammaBin, $epsilonBin = "", ""
for ($i = 0; $i -lt $in[0].Length; $i++) {
    $gammaBit, $epsilonBit = $in | Group-Object { $_[$i] } -NoElement | Sort-Object -Descending -Property Count | Select-Object -ExpandProperty Name -First 1 -Last 1
    $gammaBin += $gammaBit
    $epsilonBin += $epsilonBit
}

$gammaRate = [Convert]::ToInt32($gammaBin, 2)
$epsilonRate = [Convert]::ToInt32($epsilonBin, 2)

"Result: $gammaRate (gammaRate) * $epsilonRate (epsilonRate) = $($gammaRate*$epsilonRate)"