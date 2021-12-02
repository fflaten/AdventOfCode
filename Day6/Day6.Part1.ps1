$answers = (Get-Content $PSScriptRoot\input.txt -Raw) -split '(?m)\s*^\s+$\s*' #Split group answers by blank line

$groupYes = @()

foreach ($answer in $answers) {
    $groupYes += @($answer.ToCharArray() -match '\w' | Group-Object).Count
}

$groupYesSum = 0
$groupYes | ForEach-Object { $groupYesSum += $_ }
"Sum of 'unique yes-answered questions' in all groups = $groupYesSum"