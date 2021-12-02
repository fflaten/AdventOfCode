$myBagOfAdapters = New-Object System.Collections.ArrayList
Get-Content "$PSScriptRoot\input-demo.txt" | ForEach-Object { $myBagOfAdapters.Add(($_.Trim() -as [int])) > $null }
$myBagOfAdapters.Sort()

$AdapterFlexLower = 1..3
$BuiltInFlexHigher = 3
$outletJolt = 0
$connections = New-Object System.Collections.ArrayList # (Outlet) - Adapter - Adapter - (Device)
$cache = @{} # AdapterIndex = list of combinations (strings)

function testAdapter($CurrentJolt,$NextAdapterIndex) {
    $currentAdapter = $myBagOfAdapters[$NextAdapterIndex]

    if($nextAdapters = $NextAdapterIndex..($myBagOfAdapters.Count-$NextAdapterIndex) | Where-Object { ($myBagOfAdapters[$_] - $currentAdapter) -in $AdapterFlexLower }) {
        foreach ($nAdapter in $nextAdapters) {
            if($cache.ContainsKey($nAdapter)) {
                foreach ($conn in $cache["$nAdapter"]) {
                    "$currentAdapter - $conn"
                }
            } else {
                $connStrings = testAdapter -CurrentJolt $CurrentJolt -NextAdapterIndex $nAdapter | ForEach-Object {
                    "$currentAdapter - $_"
                }
                $cache.Add($nAdapter,$connStrings) > $null
                $connStrings
            }
        }
    } else {
        #"end of the road"
        # (0) - 1 - 3 - (6)
        "$currentAdapter - ($($currentAdapter+$BuiltInFlexHigher))"
    }

    # if($| ForEach-Object {
    #     testAdapter $adapter $_ $availableAdapters.Clone() $string
    #     "$string - ($($adapter+$BuiltInFlexHigher))"
    # }
}

for ($firstIndex=0; $myBagOfAdapters[$firstIndex] -in $AdapterFlexLower; $firstIndex++) {
    testAdapter -CurrentJolt $outletJolt -NextAdapterIndex $firstIndex | ForEach-Object {
        $connections.Add("($($outletJolt)) - $_") > $null
    }
}

"Part 2"
"Number of possible connection: $($connections.Count)"
#$connections

#Should be rewritten to use index + availableAdapters