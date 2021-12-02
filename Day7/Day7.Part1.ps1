$ruleList = Get-Content $PSScriptRoot\input.txt
$rules = @{}
foreach ($rule in $ruleList) {
    if($rule -match '(.*?) bag(?:s?) contain(?:s?) (.*)\.$') {
        $key = $Matches[1]
        switch -Regex ($Matches[2] -split ', ') {
            "no other bags" { }
            "(\d+) (.*) bag(?:s?)" { 
                $count = $Matches[1] -as [int]
                $color = $Matches[2]
                
                if(-not $rules.ContainsKey($key)) {
                    $rules.Add($key,@{$color = $count})
                } else {
                    $rules[$key][$color] += $count
                }
             }
            Default { Write-Warning "Unsupported input: $_" }
        }
    }
}

#$rules

"Found rules for $($rules.Keys.Count) bag types"

function processBagTypeContent ($bagKey) {
    #Write-Host "Processing $bagKey for possible content"
    
    $res = @{}
    if($rules.ContainsKey($bagKey)) { 
        foreach($content in $rules[$bagKey].GetEnumerator()) {
            $contentKey = $content.Key
            $contentTimes = $content.Value
            # Add direct items x times
            $res[$contentKey] += $contentTimes
            
            if(-not $possibleContentPerBag.ContainsKey($contentKey)) {
                processBagTypeContent $contentKey
            }
            $recursiveContent = $possibleContentPerBag[$contentKey]
            foreach($c in $recursiveContent.GetEnumerator()) {             
                # Add indirect items x time
                $res[$c.Key] += $c.Value*$contentTimes
            }
        }        
    }

    # Add bag to list when processed
    $possibleContentPerBag.Add($bagKey,$res)
}

$possibleContentPerBag = @{}
$rules.GetEnumerator() | Sort-Object { $_.Value.Count } | ForEach-Object {
    if(-not $possibleContentPerBag.ContainsKey($_.Key)) { processBagTypeContent $_.Key }
}


# Part 1
$wantedBag = "shiny gold"
$wantedNumber = 1
$availableOptions = $possibleContentPerBag.GetEnumerator() | Foreach-Object {
    if($_.Value[$wantedBag] -ge $wantedNumber) { $_.Key }
}

#"$($availableOptions.Count) possible solutions: $($availableOptions -join ', ')"
"There are $($availableOptions.Count) bags that can contain a $wantedBag bag"