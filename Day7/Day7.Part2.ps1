# Load data from Part1-script
. "$PSScriptRoot\Day7.Part1.ps1"

$sum = $possibleContentPerBag["shiny gold"].Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum

"A shiny gold bag will contain $sum bags"