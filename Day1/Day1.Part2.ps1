# Part 2

$report = Get-Content $PSScriptRoot\input.txt | ForEach-Object { $_.Trim() -as [int] }
$MatchNumber = 2020

# Brute force, ineffective way. Could've excluded all duplicates etc.
# Ex. left * right == right * left, so we'll get a duplicate result, but the evaluation is quick anyways
foreach ($left in $report) {
    foreach ($middle in $report) {
        foreach ($right in $report) {
            if(($left -ne $right) -and ($middle -ne $right) -and (($left + $middle + $right) -eq $MatchNumber)) {
                Write-Host "Match found. $left + $middle + $right = $MatchNumber"
                Write-Host "Product is . $left * $middle * $right = $($left*$middle*$right)"
            }
        }
    }
}