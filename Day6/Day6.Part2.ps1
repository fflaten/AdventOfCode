$groups = (Get-Content $PSScriptRoot\input.txt -Raw) -split '(?m)\s*^\s+$\s*' #Split group answers by blank line

$groupYes = @()

foreach ($group in $groups) {
    $yesAnswers = @{}

    $answers = ($group -split "`n" | % trim)
    foreach ($answer in $answers) {
        $answer.ToCharArray() -match '\w' | Group-Object | ForEach-Object {
            if($yesAnswers.ContainsKey($_.Name)) {
                $yesAnswers[$_.Name] += 1
            } else {
                $yesAnswers.Add($_.Name,1)
            }
        }
    }

    $groupEveryoneYes = $yesAnswers.GetEnumerator() | Foreach-Object { if($_.Value -eq $answers.Count) { $_.Key } }
    $groupYes += $groupEveryoneYes.Count
}

$groupYesSum = 0
$groupYes | ForEach-Object { $groupYesSum += $_ }
"Sum of 'unique yes-answered questions' in all groups = $groupYesSum"