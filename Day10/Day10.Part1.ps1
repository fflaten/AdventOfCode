$myBagOfAdapters = New-Object System.Collections.ArrayList
Get-Content "$PSScriptRoot\input.txt" | ForEach-Object { $myBagOfAdapters.Add(($_.Trim() -as [int])) > $null }
$myBagOfAdapters.Sort()

$AdapterFlexLower = 1..3
$BuiltInFlexHigher = 3
$outletJolt = 0
$connections = [ordered]@{} # Adapter = NextAdapter

function testAdapter($currentJolt,$adapter) {
    Write-Host "Testing adapter $adapter at currentJolt $currentJolt"
    $availableAdapters.Remove($adapter)
    $connections.Add($currentJolt,$adapter)
    
    if($nextAdapter = $availableAdapters | Where-Object { ($_ - $adapter) -in $AdapterFlexLower } | Select-Object -First 1) {
        testAdapter $adapter $nextAdapter
    } else {
        "End of the road. Adding connection to device"
        $connections.Add($adapter,($adapter+$BuiltInFlexHigher))
    }
}

$myBagOfAdapters | Where-Object { $_ -in $AdapterFlexLower } | Select-Object -First 1 | ForEach-Object {
    $availableAdapters = $myBagOfAdapters.Clone()
    testAdapter $outletJolt $_
}

"Part 1"
if($availableAdapters.Count -eq 0) {
    $diffGroups = $connections.GetEnumerator() | Group-Object { "$([System.Math]::Abs(($_.Value - $_.Key)))" } -AsHashTable
    
    "Number of 1-diffs: $($diffGroups["1"].Count)" 
    "Number of 3-diffs: $($diffGroups["3"].Count)"
    "Product: $($diffGroups["1"].Count * $diffGroups["3"].Count)"
} else {
    "ERROR - Still $($availableAdapter.Count) adapters remaining.."
}