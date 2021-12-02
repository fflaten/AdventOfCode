$myBagOfAdapters = New-Object System.Collections.ArrayList
Get-Content "$PSScriptRoot\input.txt" | ForEach-Object { $myBagOfAdapters.Add(($_.Trim() -as [int])) > $null }
$myBagOfAdapters.Sort()

$AdapterFlexLower = 1..3
$BuiltInFlexHigher = 3
$outletJolt = 0
$connections = New-Object System.Collections.ArrayList # (Outlet) - Adapter - Adapter - (Device)

function testAdapter($currentJolt,$adapter,$availableAdapters,$string) {
    #Write-Host "Testing adapter $adapter at currentJolt $currentJolt"
    $availableAdapters.Remove($adapter)
    $string = "$string - $adapter"

    $foundNext = $false
    $availableAdapters | Where-Object { ($_ - $adapter) -in $AdapterFlexLower } | ForEach-Object {
        $foundNext = $true
        testAdapter $adapter $_ $availableAdapters.Clone() $string
    }

    if($foundNext -eq $false) {
        #"End of the road. Adding connection to device"
        $connections.Add("$string - ($($adapter+$BuiltInFlexHigher))") > $null
    }
}

$myBagOfAdapters | Where-Object { $_ -in $AdapterFlexLower } | ForEach-Object {
    $availableAdapters = $myBagOfAdapters.Clone()
    testAdapter $outletJolt $_ $availableAdapters "($outletJolt)"
}

"Part 2"
"Number of possible connection: $($connections.Count)"
#$connections

#Should be rewritten to use index + availableAdapters